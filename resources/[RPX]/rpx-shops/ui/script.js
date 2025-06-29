var ShowingToast = false;
var ShopData = null;

window.addEventListener("message", (event) => {
    const action = event.data.action;
    switch (action) {
        case "OPEN_SHOP":
            ShopData = event.data.data;
            SetupShopMenu();
            $("#shopmenu").show();
            break;
        case "CLOSE_SHOP":
            $("#shopmenu").hide();
            break;
        default:
            return;
    }
});

function SetupShopMenu() {
    $("#shopitems").empty();
    $(".purchase").html("Purchase");
    $("#amount").val("");
    $("#storename").html(ShopData.name);
    ShopData.items.forEach(item => {
        $("#shopitems").append(`
            <div class="shopitem" itemname="${item.item}">
                <div class="shopitemname">${item.name}</div>
                <div class="shopitemprice">${(item.price).toLocaleString('en-US', { 
                    style: 'currency', 
                    currency: 'USD' 
                })}</div>
                <div class="shopitemimg"><img src="nui://rpx-inventory/web/images/${item.img}"/></div>
            </div>
        `);
    });

    $(".shopitem").click(function() {
        $(".shopitem").removeClass("selected");
        $(this).addClass("selected");
        $(".purchase").html("Purchase " + $(this).find(".shopitemname").html());
    });    
}

// This enables the player to close the NUI with the escape key.
$(document).keyup(function(e) {
    if (e.keyCode == 27) {
        $("#multicharmenu").hide();
        $.post(`https://${GetParentResourceName()}/CloseNUI`);
    }
});


$(".purchase").click(function() {
    $.post(`https://${GetParentResourceName()}/PurchaseItem`, JSON.stringify({
        item: $("#shopitems .shopitem.selected").attr("itemname"),
        amount: $("#amount").val()
    }));
});

Toast = function(text, time) {
    if(!ShowingToast) {
        ShowingToast = true;
        $("#toast").html("<p>" + text + "</p>");
        $("#toast").fadeIn(250, function () {
            setTimeout(function() {
                $("#toast").fadeOut(250, function () {
                    $("#toast").html("");
                    ShowingToast = false;
                });
            }, time);
        });
    }
}
