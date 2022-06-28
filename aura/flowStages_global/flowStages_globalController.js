({
    init : function(component, event, helper) {
       var flow = component.find("flow");
       flow.startFlow(component.get("v.flowName"));
    },
 
    // When each screen loads ... 
    statusChange : function(component, event, helper) {
       // Pass $Flow.ActiveStages into the activeStages attribute
       // and $Flow.CurrentStage into the currentStage attribute
       component.set("v.currentStage", event.getParam("currentStage"));
       component.set("v.activeStages", event.getParam("activeStages"));
       
       var progressIndicator = component.find("progressIndicator");
       var body = [];
       
       for(let stage of component.get("v.activeStages")) {
          // For each stage in activeStages...
          $A.createComponent(
             "lightning:progressStep",
             {
                // Create a progress step where label is the 
                // stage label and value is the stage name
                "aura:id": "step_" + stage.name,
                "label": stage.label,
                "value": stage.name
             },
             function(newProgressStep, status, errorMessage) {
                //Add the new step to the progress array
                if (status === "SUCCESS") {
                body.push(newProgressStep);
                }
                else if (status === "INCOMPLETE") {
                   // Show offline error
                   console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                   // Show error message
                   console.log("Error: " + errorMessage);
                }
             }
          );
       }
       progressIndicator.set("v.body", body);
    }
 })