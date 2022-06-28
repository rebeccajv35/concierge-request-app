({
    
    doInitialize : function(component, event, helper) {
        component.set('v.displayValues', {});
        component.set('v.picklists', {});
        component.set('v.participants', null);
        component.set('v.contacts', null);
        component.set('v.participant', null);
        component.set('v.columns', null);
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        helper.isPortalUser(component, helper);

        helper.fetchPicklistValues(component, 'Contact','Race__c',true);
        helper.fetchPicklistValues(component, 'Contact','Ethnicity__c',true);
        helper.fetchPicklistValues(component, 'Contact','Employee_Type__c',true);
        helper.fetchPicklistValues(component, 'Kit_Locator__c','Reason_for_Testing__c',true);
        helper.fetchPicklistValues(component, 'Kit_Locator__c','Symptoms_Present__c',true);
        helper.fetchPicklistValues(component, 'Kit_Locator__c','Discarded_Reason__c',true);
        
        
        
    },
    
    doScrollToTopSearch : function(component, event, helper) {
        //employeeIdSearch
        var input = component.find("firstNameSearch");
        if(input)
        {
            input.focus();
        }
        
    },
    
   
    doSelectProgram : function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        var listValue = component.get("v.picklists.Program_Options");
        var programId =  event.getSource().get("v.value");
        var programName = '';
        
        for (var i=0; i<listValue.length; i++) {
            var opt = listValue[i];
            if(opt.value == programId)
            {
                programName = opt.label;
            }
            
        }
        
        //clear company previous selection
        component.set('v.companyId', null);
        component.set('v.companyName', null);
        
        //clear facility previous selection
        component.set('v.facilityId', null);
        component.set('v.facilityName', null);
        
        var picklistOptions = component.get('v.picklists');
        picklistOptions['Company_Options'] = null;
        component.set('v.picklists', picklistOptions);
        
        var picklistOptions = component.get('v.picklists');
        picklistOptions['Facility_Options'] = null;
        component.set('v.picklists', picklistOptions);
        
        component.set('v.hasCompany', false);
        component.set('v.hasFacility', false);
        
    
        //set program attributes
        component.set('v.programId',programId);
        component.set('v.programName', programName);
        
        //get companies for program
        helper.getAccountProgramCompanies(component, helper);
        
        //get program providers
        helper.getApprovingProviders(component, helper);
        
        //get program customizations
        helper.getProgramCustomizations(component, helper,programId);
        
        
    },
    
    doSelectCompany : function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        var accountCompanyId = event.getSource().get("v.value");
        var listValue = component.get("v.picklists.Company_Options");
        var accountCompanyName = '';
        
        for (var i=0; i<listValue.length; i++) {
            var opt = listValue[i];
            console.log('label ' + opt.label);
            if(opt.value == accountCompanyId)
            {
                accountCompanyName = opt.label;
            }
            
        }
        
        //clear facility previous selection
        component.set('v.facilityId', null);
        component.set('v.facilityName', null);
        
        var picklistOptions = component.get('v.picklists');
        picklistOptions['Facility_Options'] = null;
        component.set('v.picklists', picklistOptions);
        component.set('v.hasFacility', false);
        
        //set company attributes
        component.set('v.companyName', accountCompanyName);
        component.set('v.companyId', accountCompanyId);
        
        //get company facilities
        helper.getProgramCompanyFacility(component, helper);
    },
    
    doSelectFacility : function(component, event, helper)
    {
        
        var accountFacilityId = event.getSource().get("v.value");
        var listValue = component.get("v.picklists.Facility_Options");
        var accountFacilityName = '';
        
        for (var i=0; i<listValue.length; i++) {
            var opt = listValue[i];
            if(opt.value == accountFacilityId)
            {
                accountFacilityName = opt.label;
            }
            
        }
        component.set('v.facilityName', accountFacilityName);
        
    },
    
    doSelectPhysician : function(component, event, helper)
    {
        var PhysicianId = event.getSource().get("v.value");
        var listValue = component.get("v.picklists.Physician_Options");
        var PhysicianName = '';
        
        for (var i=0; i<listValue.length; i++) {
            var opt = listValue[i];
            if(opt.value == varPhysicianId)
            {
                PhysicianName = opt.label;
            }
            
        }
        component.set('v.physicianName', PhysicianName);
        
    },
    
    doSelectDiscardedReason : function(component, event, helper)
    {
        var discardedReason = event.getSource().get("v.value");
        var listValue = component.get("v.picklists.Discarded_Reason__c");
        var discardedReasonLabel = '';
        
        
        for(var i=0; i<listValue.length; i++){
            var opt = listValue[i];
            if(opt.value == discardedReason)
            {
                discardedReasonLabel = opt.Label;
            }
        }
        
        if(discardedReasonLabel == 'Other'){
        		component.set('v.isOther', true);
            }
    },
    
    showParticipantSearch : function(component, event, helper)
    {
        component.set('v.searchErrorMessages', []);
        component.set('v.canSearch', true);
        var programId = component.get('v.programId');
        var companyId = component.get('v.companyId');
        var facilityId = component.get('v.facilityId');
        let errorMessages = [];
        if(programId == null || programId == '')
        {
            component.set('v.canSearch', false);
            
            errorMessages.push({title: "Required", message: "Please select a program"});
            component.set('v.canSearch', false);
        }
        if((companyId == null || companyId == '') && component.get('v.hasCompany') == true)
        {
            component.set('v.canSearch', false);
            
            errorMessages.push({title: "Required", message: "Please select a group"});
            component.set('v.canSearch', false);
        }
        if((facilityId == null || facilityId == '') && component.get('v.hasFacility') == true)
        {
            component.set('v.canSearch', false);
            
            errorMessages.push({title: "Required", message: "Please select a location."});
            component.set('v.canSearch', false);
        }
        
        
        if(errorMessages.length == 0)
        {
            helper.toggleModal(component, 'ParticipantSearch');
        }
        
        
        
        component.set('v.searchErrorMessages', errorMessages);
    },
       
    closeModalParticipantSearch : function(component, event, helper)
    {
        
        helper.toggleModal(component, 'ParticipantSearch');
        helper.resetParticipantForm(component, helper);
        
    },
    closeModalDiscardKit : function(component, event, helper)
    {
        helper.toggleModal(component, 'DiscardKit');
        
    },
    
    ignoreCloseModalParticipantSearch : function(component, event, helper)
    {
        helper.toggleModal(component, 'ExitMessage');
        helper.toggleModal(component, 'ParticipantSearch');
    },
    
    forceCloseModalParticipantSearch : function(component, event, helper)
    {
        //helper.toggleModal(component, 'ParticipantSearch');
        helper.toggleModal(component, 'ExitMessage');
        helper.resetParticipantForm(component, helper);
    },
    
    doParticipantSearch: function(component, event, helper)
    {
        component.set('v.canEnrollNew', true);
        helper.getProgramParticipants(component, helper);
        
    },
    
    doAddNewParticipant: function(component, event, helper)
    {
        helper.initializeNewParticipant(component, helper); 
        helper.initializeNewKit(component, helper); 
        
        
    },
    
    doSelectParticipantFromKit: function(component, event, helper)
    {
        helper.toggleModal(component, 'Kit');
        var kitLocator = component.get('v.kitLocator');
        component.set('v.participant', kitLocator.Program_Participant__r);
        helper.toggleModal(component, 'ParticipantSearch');
        helper.getParticipantProgramKits(component, helper);
    },
    
    doSelectParticipant: function(component, event, helper)
    {
        var participant = event.getSource().get('v.value');
        component.set('v.participant', participant);
        helper.initializeNewKit(component, helper); 
        helper.getParticipantProgramKits(component, helper);
            
    },
    
    doRemoveKit: function(component, event, helper)
    {
        let participantKitLocator = event.getSource().get('v.value');
        helper.removeParticipantKit(component, helper, participantKitLocator);
    },
    
    doSelectDiscardKit: function(component, event, helper){
        
        let kit = event.getSource().get('v.value');
        component.set('v.selectedKitLocator', kit);
        //component.set('v.selectedKitLocator', kit);
        helper.toggleModal(component, 'DiscardKit');
        
    },
    
    doDiscardKit: function(component, event, helper)
    {
        let participantKitLocator = event.getSource().get('v.value');
        helper.discardKit(component, helper, participantKitLocator);
    },
    
    
    doValidateParticipantKit: function(component, event, helper)
    {
        var participantKit = component.get('v.participantKit');
        var kitLocatorReEnter = component.get('v.kitLocatorReEnter');
        var kitLocatorNotValidMessage = component.get('v.kitLocatorNotValidMessage');
        component.set('v.kitLocatorNotValid', false);
        component.set('v.kitLocatorNotValidMessage', null);
        if(participantKit.Name != kitLocatorReEnter && kitLocatorReEnter != null && kitLocatorReEnter != '')
        {
            component.set('v.kitLocatorNotValidMessage', 'Kit Locator entries do not match');
            component.set('v.kitLocatorNotValid', true);
        }else
        {
            if(kitLocatorReEnter != null && kitLocatorReEnter != '')
            {
                helper.checkValidParticipantKit(component, helper, participantKit.Name);
            }
            
        }
        
        
        
        //Not a valid kit locator.  Please check your entry.
        //kitLocatorNotValidMessage
        
        
    },
    
    doCloseKitSearch: function(component, event, helper)
    {
        helper.toggleModal(component, 'Kit');
        component.set('v.kitSearchName', null);
    },
    
    doKitSearch: function(component, event, helper)
    {
        
        helper.searchKit(component, helper);
    },
    
    doFormatTemperature: function(component, event, helper)
    {
        let temp = event.getSource().get('v.value');
        
        var rounded = temp.setScale(1);
        component.set('v.participantKit.Temperature__c', rounded);
    },
    
    doSaveRecord: function(component, event, helper)
    {
        
        if(helper.isParticipantDataValid(component, helper) == true)
        {
            helper.saveParticipant(component, helper);
        }
    },

    doSaveDiscardedKit: function(component, event, helper)
    {
        if(helper.isDiscardKitDataValue(component, helper) == true){
            var selectedKit = component.get('v.selectedKitLocator');
            //let selectedKit = component.get('v.selectedKitLocator');
            helper.doSaveDiscardedKit(component, helper, selectedKit);
        }
    },
    
    toggleLookup: function(component, event, helper){
        var values = event.getSource().get('v.value');
        var sObject = values.split('|')[0];
        var target = values.split('|')[1];
        component.set('v.modalTarget', target);
        component.set('v.modalSobject', sObject);
        helper.toggleModal(component, sObject);
    },
    
    
    handleObjectLookupEvent: function (component, event, helper) {
        
        var sObjectType = event.getParam('sObjectType');
        if ( sObjectType == 'Account'){

        //clear program attributes
        component.set('v.programId',null);
        component.set('v.programName', null);

         //clear company previous selection
        component.set('v.companyId', null);
        component.set('v.companyName', null);
        
        //clear facility previous selection
        component.set('v.facilityId', null);
        component.set('v.facilityName', null);

        var picklistOptions = component.get('v.picklists');
        picklistOptions['Program_Options'] = null;
        component.set('v.picklists', picklistOptions);
        
        var picklistOptions = component.get('v.picklists');
        picklistOptions['Company_Options'] = null;
        component.set('v.picklists', picklistOptions);
        
        var picklistOptions = component.get('v.picklists');
        picklistOptions['Facility_Options'] = null;
        component.set('v.picklists', picklistOptions);
        
        component.set('v.hasCompany', false);
        component.set('v.hasFacility', false);
        
    
      

            var accountId = event.getParam('recordId');
            console.log('accountid recordid = ' + accountId);
            helper.getAccountInformation(component, helper, accountId);
           
        }
    },
    
    
})