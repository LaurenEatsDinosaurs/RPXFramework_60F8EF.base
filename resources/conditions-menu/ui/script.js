var ShowingToast = false;

window.addEventListener("message", (event) => {     /**When a message is sent to the window object */
    const action = event.data.action;
    switch (action) {
        case "OPEN_CONDITIONS":     /**If action = OPEN_CONDITIONS - Takes condition types and associated conditions from event.data object*/
            $(".condition1type").attr("src","img/condition_"+event.data.condition1type+".png");     /**Sets the displayed image to the appropriate one matching condition type */
            $(".condition1").html(event.data.condition1);                                           /**Sets condition1 class to condition1 variable value */
            $(".condition2type").attr("src","img/condition_"+event.data.condition2type+".png");     /**Sets the displayed image to the appropriate one matching condition type */
            $(".condition2").html(event.data.condition2);                                           /**Sets condition2 class to condition2 variable value */
            $(".condition3type").attr("src","img/condition_"+event.data.condition3type+".png");     /**Sets the displayed image to the appropriate one matching condition type */
            $(".condition3").html(event.data.condition3);                                           /**Sets condition3 class to condition3 variable value */
            $(".condition4type").attr("src","img/condition_"+event.data.condition4type+".png");     /**Sets the displayed image to the appropriate one matching condition type */
            $(".condition4").html(event.data.condition4);                                           /**Sets condition4 class to condition4 variable value */
            $(".condition5type").attr("src","img/condition_"+event.data.condition5type+".png");     /**Sets the displayed image to the appropriate one matching condition type */
            $(".condition5").html(event.data.condition5);                                           /**Sets condition5 class to condition5 variable value */
            $("#conditionsmenu").fadeIn(200);
            break;
        case "CLOSE_CONDITIONS":    /**If action = CLOSE_BANK - Fade out bank menu*/
            $("#conditionsmenu").fadeOut(200);
            break;
        case "ADD_CONDITION":   /**If action = ADD_CONDITIONS - Takes new balance value from event.data object, formats, and sets that string as the HTML content of .balance. Then shows bank menu*/
            $(".balance").html(event.data.balance.toLocaleString('en-US', {
                style: 'currency',
                currency: 'USD'
            }));
            break;
        default:
            return;
    }
});

$("#closebutton").click(function() {                            /*When an element with class "#closebutton" is clicked*/
    $("#conditionsmenu").fadeOut(200); 
    $.post(`https://${GetParentResourceName()}/CloseNUI`);      /**Sends POST request to URL (based on resource name) to notify server that closeNUI action has occurred */
});

$("#savebutton").click(function() {                             /*When an element with class "#savebutton" is clicked*/
    $("#bankmenu").fadeOut(200, function() {                    /**Fades out banking menu, clears Amount field, fades in transaction menu, updates the heading and Transact button to say "Withdraw" */
        $("#amount").val(""); 
        $("#transactionmenu").fadeIn(200);
        $("#transhead").html("Withdraw");
        $(".transact").html("Withdraw");
    });
});

$(".transact").click(function() {    /*When an element with class ".transact" is clicked*/
    var amount = $("#amount").val();    /**Makes "amount" equal to whatever was input in the textbox */
    if(amount == "") {      /**If no amount entered, display warning for 2.5 seconds */
        Toast("Please enter an amount.", 2500);
    } else {
        $.post(`https://${GetParentResourceName()}/Transact`, JSON.stringify({    /**Sends POST request to URL (based on resource name) to notify server that Transact action has occurred */
            type: TransactionType,    /**i.e. Withdrawal or deposit */
            amount: amount
        }));
        $("#transactionmenu").fadeOut(200, function() {
            $("#bankmenu").fadeIn(200);
        });
    }
});


$(document).keyup(function(e) {    /**If ESC key is pressed, close menu */
    if (e.keyCode == 27) {
        $("#conditionsmenu").fadeOut(200);
        $.post(`https://${GetParentResourceName()}/CloseNUI`);    /**Sends POST request to URL (based on resource name) to notify server that closeNUI action has occurred */
    }
});

Toast = function(text, time) {    /**Check no toast already being shown, then update to show given text, fade in for 2.5 seconds, fade out for 2.5 seconds, then clears the toast of the text*/
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