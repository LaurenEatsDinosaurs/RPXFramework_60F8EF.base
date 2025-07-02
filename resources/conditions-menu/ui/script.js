var ShowingToast = false;

window.addEventListener("message", (event) => {                                                     /**When a message is sent to the window object */
    const action = event.data.action;
    switch (action) {
        case "OPEN_CONDITIONS":                                                                     /**If action = OPEN_CONDITIONS - Takes condition types and associated conditions from event.data object*/
            var deletebutton1 = document.getElementById("deletebutton1");                         /**Find all delete buttons */
            var deletebutton2 = document.getElementById("deletebutton2");
            var deletebutton3 = document.getElementById("deletebutton3");
            var deletebutton4 = document.getElementById("deletebutton4");
            var deletebutton5 = document.getElementById("deletebutton5");

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

            if(event.data.condition1type.includes("None")) {                                        /**If condition is blank, don't show X button; if not, show it */
                deletebutton1.style.display = "none";
            } else {
                deletebutton1.style.display = "inline-block";
            }

            if(event.data.condition2type.includes("None")) {                                        /**If condition is blank, don't show X button; if not, show it */
                deletebutton2.style.display = "none";
            } else {
                deletebutton2.style.display = "inline-block";
            }            

            if(event.data.condition3type.includes("None")) {                                        /**If condition is blank, don't show X button; if not, show it */
                deletebutton3.style.display = "none";
            } else {
                deletebutton3.style.display = "inline-block";
            }            

            if(event.data.condition4type.includes("None")) {                                        /**If condition is blank, don't show X button; if not, show it */
                deletebutton4.style.display = "none";
            } else {
                deletebutton4.style.display = "inline-block";
            }

            if(event.data.condition5type.includes("None")) {                                        /**If condition is blank, don't show X button; if not, show it */
                deletebutton5.style.display = "none";
            } else {
                deletebutton5.style.display = "inline-block";
            }

            $("#conditionsmenu").fadeIn(200);
            break;
        case "CLOSE_CONDITIONS":                                                                    /**If action = CLOSE_BANK - Fade out bank menu*/
            $("#conditionsmenu").fadeOut(200);
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

$("#addbutton").click(function() {                                                                                                                  /*When an element with class "#addbutton" is clicked*/ 
    var conditiontextbox = document.getElementById("condition");
    var conditiondropdown = document.getElementById("conditiontype");

    let condition1image = document.getElementById("condition1type");                                                                                /**Refers to the elementID for each image, so we can grab the image source */
    condition1src = condition1image.getAttribute("src");
    let condition2image = document.getElementById("condition2type");                                                                                
    condition2src = condition2image.getAttribute("src");
    let condition3image = document.getElementById("condition3type");                                                                                
    condition3src = condition3image.getAttribute("src");
    let condition4image = document.getElementById("condition4type");                                                                                
    condition4src = condition4image.getAttribute("src");
    let condition5image = document.getElementById("condition5type");                                                                                
    condition5src = condition5image.getAttribute("src");
  
    if(conditiontextbox !== null && conditiontextbox.value === "") {                                                                                        /**If the textbox is empty, display toast error*/
       Toast("Please enter a condition.", 2500);
    } else {                                                                                                                                                /**If no condition type has been selected, display toast error */
        if(conditiondropdown !== null && conditiondropdown.options[conditiondropdown.selectedIndex].text === "None") {
            Toast("Please select a condition type.", 2500);
        } else {                                                                                                                                            /**If textbox has text and condition type is selected, proceed with add */
            if(condition1src.includes("None")) {                                                                                                            /**If Condition1 slot is empty */
                $(".condition1type").attr("src","img/condition_"+conditiondropdown.options[conditiondropdown.selectedIndex].text+".png");                   /**Make Condition1type equal to dropdown selection */
                $(".condition1").html(conditiontextbox.value);                                                                                              /**Make Condition1 equal to textbox input */
                deletebutton1.style.display = "inline-block";                                                                                               /**Show delete button */
            } else {
                if(condition2src.includes("None")) {                                                                                                        /**If Condition2 slot is empty */
                    $(".condition2type").attr("src","img/condition_"+conditiondropdown.options[conditiondropdown.selectedIndex].text+".png");               /**Make Condition2type equal to dropdown selection */
                    $(".condition2").html(conditiontextbox.value);                                                                                          /**Make Condition2 equal to textbox input */
                    deletebutton2.style.display = "inline-block";                                                                                           /**Show delete button */
                } else {
                    if(condition3src.includes("None")) {                                                                                                    /**If Condition3 slot is empty */
                        $(".condition3type").attr("src","img/condition_"+conditiondropdown.options[conditiondropdown.selectedIndex].text+".png");           /**Make Condition3type equal to dropdown selection */
                        $(".condition3").html(conditiontextbox.value);                                                                                      /**Make Condition3 equal to textbox input */
                        deletebutton3.style.display = "inline-block";                                                                                       /**Show delete button */
                    } else {
                        if(condition4src.includes("None")) {                                                                                                /**If Condition4 slot is empty */
                            $(".condition4type").attr("src","img/condition_"+conditiondropdown.options[conditiondropdown.selectedIndex].text+".png");       /**Make Condition4type equal to dropdown selection */
                            $(".condition4").html(conditiontextbox.value);                                                                                  /**Make Condition4 equal to textbox input */
                            deletebutton4.style.display = "inline-block";                                                                                   /**Show delete button */
                        } else {
                            if(condition5src.includes("None")) {                                                                                            /**If Condition5 slot is empty */
                                $(".condition5type").attr("src","img/condition_"+conditiondropdown.options[conditiondropdown.selectedIndex].text+".png");   /**Make Condition5type equal to dropdown selection */
                                $(".condition5").html(conditiontextbox.value);                                                                              /**Make Condition5 equal to textbox input */
                                deletebutton5.style.display = "inline-block";                                                                               /**Show delete button */
                            }
                        }
                    }
                }
            }
        }
    }
});


$("#deletebutton1").click(function() {                                                              /*When an element with class "#deletebutton1" is clicked*/ 
    $(".condition1type").attr("src","img/condition_None.png");                                      /**Sets image to "None" (empty black) */
    $(".condition1").html("");                                                                      /**Sets condition1 text to "" */
    var deletebutton1 = document.getElementById("deletebutton1");
    deletebutton1.style.display = "none";
});

$("#deletebutton2").click(function() {                                                              /*When an element with class "#deletebutton2" is clicked*/ 
    $(".condition2type").attr("src","img/condition_None.png");                                      /**Sets image to "None" (empty black) */
    $(".condition2").html("");                                                                      /**Sets condition1 text to "" */
    var deletebutton2 = document.getElementById("deletebutton2");
    deletebutton2.style.display = "none";
});

$("#deletebutton3").click(function() {                                                              /*When an element with class "#deletebutton3" is clicked*/ 
    $(".condition3type").attr("src","img/condition_None.png");                                      /**Sets field1's image to "None" (empty black) */
    $(".condition3").html("");                                                                      /**Sets condition1 text to "" */
    var deletebutton3 = document.getElementById("deletebutton3");
    deletebutton3.style.display = "none";
});

$("#deletebutton4").click(function() {                                                              /*When an element with class "#deletebutton4" is clicked*/ 
    $(".condition4type").attr("src","img/condition_None.png");                                      /**Sets field1's image to "None" (empty black) */
    $(".condition4").html("");                                                                      /**Sets condition1 text to "" */
    var deletebutton4 = document.getElementById("deletebutton4");
    deletebutton4.style.display = "none";
});

$("#deletebutton5").click(function() {                                                              /*When an element with class "#deletebutton5" is clicked*/ 
    $(".condition5type").attr("src","img/condition_None.png");                                      /**Sets field1's image to "None" (empty black) */
    $(".condition5").html("");                                                                      /**Sets condition1 text to "" */
    var deletebutton5 = document.getElementById("deletebutton5");
    deletebutton5.style.display = "none";
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

    console.log("On save, conditions are",condition1type,condition1,condition2type,condition2,condition3type,condition3,condition4type,condition4,condition5type,condition5)

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

