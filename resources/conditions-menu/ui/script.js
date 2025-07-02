var ShowingToast = false;

window.addEventListener("message", (event) => {                                                     /**When a message is sent to the window object */
    const action = event.data.action;
    switch (action) {
        case "OPEN_CONDITIONS":                                                                     /**If action = OPEN_CONDITIONS - Takes condition types and associated conditions from event.data object*/
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
            DisableCamera();
            break;
        case "CLOSE_CONDITIONS":                                                                    /**If action = CLOSE_BANK - Fade out bank menu*/
            $("#conditionsmenu").fadeOut(200);
            EnableCamera();
            break;
        case "ADD_CONDITION":                                                                       /**If action = ADD_CONDITIONS - Takes new balance value from event.data object, formats, and sets that string as the HTML content of .balance. Then shows bank menu*/
            $(".balance").html(event.data.balance.toLocaleString('en-US', {
                style: 'currency',
                currency: 'USD'
            }));
            break;
        default:
            return;
    }
});

$("#closebutton").click(function() {                                                                /*When an element with class "#closebutton" is clicked*/
    $("#conditionsmenu").fadeOut(200); 
    $.post(`https://${GetParentResourceName()}/CloseNUI`);                                          /**Sends POST request to URL (based on resource name) to notify server that closeNUI action has occurred */
});

$("#savebutton").click(function() {                                                                 /*When an element with class "#savebutton" is clicked*/ 
    let condition1image = document.getElementById("condition1type");                                /**Refers to the elementID for each image, so we can grab the image source */
    condition1src = condition1image.getAttribute("src");
    if (condition1src.includes("Health")) {                                                         /**Checks if the image source contains "Health", "Visual", "Smell", or "None" */
        condition1type = "Health";                                                                  /**Sets conditiontype depending on whether Health/Visual/Smell/None */
    } else {
        if (condition1src.includes("Visual")) {
            condition1type = "Visual";
        } else {
            if (condition1src.includes("Smell")) {
                condition1type = "Smell";
            } else {
                if(condition1src.includes("None")) {
                    condition1type = "None";
                }
            }
        }
    }
 
    let condition2image = document.getElementById("condition2type");                                /**Refers to the elementID for each image, so we can grab the image source */
    condition2src = condition2image.getAttribute("src");
    if (condition2src.includes("Health")) {                                                         /**Checks if the image source contains "Health", "Visual", "Smell", or "None" */
        condition2type = "Health";                                                                  /**Sets conditiontype depending on whether Health/Visual/Smell/None */
    } else {
        if (condition2src.includes("Visual")) {
            condition2type = "Visual";
        } else {
            if (condition2src.includes("Smell")) {
                condition2type = "Smell";
            } else {
                if(condition2src.includes("None")) {
                    condition2type = "None";
                }
            }
        }
    }

    let condition3image = document.getElementById("condition3type");                                /**Refers to the elementID for each image, so we can grab the image source */
    condition3src = condition3image.getAttribute("src");
    if (condition3src.includes("Health")) {                                                         /**Checks if the image source contains "Health", "Visual", "Smell", or "None" */
        condition3type = "Health";                                                                  /**Sets conditiontype depending on whether Health/Visual/Smell/None */
    } else {
        if (condition3src.includes("Visual")) {
            condition3type = "Visual";
        } else {
            if (condition3src.includes("Smell")) {
                condition3type = "Smell";
            } else {
                if(condition3src.includes("None")) {
                    condition3type = "None";
                }
            }
        }
    }

    let condition4image = document.getElementById("condition4type");                                /**Refers to the elementID for each image, so we can grab the image source */
    condition4src = condition4image.getAttribute("src");
    if (condition4src.includes("Health")) {                                                         /**Checks if the image source contains "Health", "Visual", "Smell", or "None" */
        condition4type = "Health";                                                                  /**Sets conditiontype depending on whether Health/Visual/Smell/None */
    } else {
        if (condition4src.includes("Visual")) {
            condition4type = "Visual";
        } else {
            if (condition4src.includes("Smell")) {
                condition4type = "Smell";
            } else {
                if(condition4src.includes("None")) {
                    condition4type = "None";
                }
            }
        }
    }

    let condition5image = document.getElementById("condition5type");                                /**Refers to the elementID for each image, so we can grab the image source */
    condition5src = condition5image.getAttribute("src");
    if (condition5src.includes("Health")) {                                                         /**Checks if the image source contains "Health", "Visual", "Smell", or "None" */
        condition5type = "Health";                                                                  /**Sets conditiontype depending on whether Health/Visual/Smell/None */
    } else {
        if (condition5src.includes("Visual")) {
            condition5type = "Visual";
        } else {
            if (condition5src.includes("Smell")) {
                condition5type = "Smell";
            } else {
                if(condition5src.includes("None")) {
                    condition5type = "None";
                }
            }
        }
    }

    let condition1 = document.getElementById("condition1").innerHTML;                               /**Gets the conditions from the NUI, saves them to condition1/2/3 etc */
    let condition2 = document.getElementById("condition2").innerHTML;
    let condition3 = document.getElementById("condition3").innerHTML;
    let condition4 = document.getElementById("condition4").innerHTML;
    let condition5 = document.getElementById("condition5").innerHTML;

    $("#conditionsmenu").fadeOut(200);                                                              /**Fades out conditions menu*/ 
    $.post(`https://${GetParentResourceName()}/SaveConditions`,JSON.stringify({                     /**Sends POST request to URL (based on resource name) to notify server that closeNUI action has occurred */
        condition1type: condition1type,                                                             /**Also sends the variables (hopefully) */
        condition1: condition1, 
        condition2type: condition2type,
        condition2: condition2,
        condition3type: condition3type,
        condition3: condition3,
        condition4type: condition4type,
        condition4: condition4,
        condition5type: condition5type,
        condition5: condition5,        
    }));                        
});

/** For X buttons           $("#transhead").html("Withdraw");
                            $(".transact").html("Withdraw"); */


$(document).keyup(function(e) {                                                                     /**If ESC key is pressed, close menu */
    if (e.keyCode == 27) {
        $("#conditionsmenu").fadeOut(200);
        $.post(`https://${GetParentResourceName()}/CloseNUI`);                                      /**Sends POST request to URL (based on resource name) to notify server that closeNUI action has occurred */
    }
});

Toast = function(text, time) {                                                                      /**Check no toast already being shown, then update to show given text, fade in for 2.5 seconds, fade out for 2.5 seconds, then clears the toast of the text*/
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

