({
    
    
    toggleModal: function(component, sObject){
        
        var device = $A.get("$Browser.formFactor");
        var modal = component.find("modalWindow"+sObject);
        $A.util.toggleClass(modal, 'slds-hide');
        
    },
    
    
    getCurrentUserInfo: function(component, helper){
        var action = component.get('c.getCurrentUserInfo');
        action.setCallback(this, function(data){
            component.set('v.currentUser', data.getReturnValue());
            //helper.getActivePrograms(component, helper);
            
        });
        $A.enqueueAction(action);
    },
    
    
    
    getApprovingProviders: function(component, helper){
        var action = component.get('c.getApprovingProviders');
        var currentUser = component.get('v.currentUser');
        component.set('v.isPhysicianSingle', false);
        action.setParams({
            programId:component.get('v.programId'),
            physicianId:component.get('v.physicianId')
        });
        
        action.setCallback(this, function(data){
            var opts = data.getReturnValue();
            var values = [];
            values = [{label:'-- Please Select --',value:''}];
            var selectedValue;
            var selectedName;
            var cntRecords = 0;
            for (var key in opts) {
                selectedValue = opts[key];
                selectedName = key;
                cntRecords++;
                values.push({
                    label: key,
                    value: opts[key]
                });
            }
            
            var picklistOptions = component.get('v.picklists');
            picklistOptions['Physician_Options'] = values;
            component.set('v.picklists', picklistOptions);
            
            if(cntRecords == 1)
            {
                component.set('v.physicianId', selectedValue);
                component.set('v.physicianName', selectedName);
                component.set('v.isPhysicianSingle', true);
            }
        });
        
        $A.enqueueAction(action);
    },
    
   

    isPortalUser: function(component, helper){
        var action = component.get('c.isPortalUser');
        
        action.setCallback(this, function(data){
            var isPortalUser = data.getReturnValue();
            component.set('v.isPortalUser', isPortalUser);
            if(isPortalUser)
            {
                helper.getAccountInformation(component, helper, null);
               
            }else{
                //user must select an account
            }
           
            
            
        });
        $A.enqueueAction(action);
    },
    
    getAccountInformation: function(component, helper, accountId){
        console.log('accountid = ' + accountId);
        var action = component.get('c.getAccountInformation');
        action.setParams({
            accountId:accountId
        });
        action.setCallback(this, function(data){
            component.set('v.account', data.getReturnValue());
            helper.getActivePrograms(component, helper);
            
        });
        $A.enqueueAction(action);
    },
    
     getActivePrograms: function(component, helper){
        var action = component.get('c.getActivePrograms');
        var account = component.get('v.account');
        component.set('v.isProgramSingle', false);
        
        action.setParams({
            accountId:account.Id,
            programId:component.get('v.programId')
        });
        
        action.setCallback(this, function(data){
            var opts = data.getReturnValue();
            var values = [];
            var cnt = 0;
            for (var key in opts) {
                   cnt++;
            }
            
            if(cnt == 0)
            {
                component.set('v.programName', 'No Active Programs');
            }else
            {
                if(cnt == 1)
                {	
                    var selectedValue = '';
                    var selectedName = '';
                    for (var key in opts) {
                        selectedValue = opts[key];
                        selectedName = key;
                    }
                    component.set('v.programId', selectedValue);
                    component.set('v.programName', selectedName);
                    component.set('v.isProgramSingle', true);
                    helper.getAccountProgramCompanies(component, helper);
                    helper.getApprovingProviders(component, helper);
                    helper.getProgramCustomizations(component, helper,selectedValue);
                   
                }else
                {
                    values = [{label:'-- Please Select --',value:''}];
                    for (var key in opts) {
                        values.push({
                            label: key,
                            value: opts[key]
                        });
                    }
                    
                    var picklistOptions = component.get('v.picklists');
                    picklistOptions['Program_Options'] = values;
                    component.set('v.picklists', picklistOptions);
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    getAccountProgramCompanies: function(component, helper){
        var action = component.get('c.getAccountProgramCompanies');
        component.set('v.isCompanySingle', false);
        component.set('v.hasCompany', false)
        action.setParams({
            programId:component.get('v.programId')
        });
        
        action.setCallback(this, function(data){
            var opts = data.getReturnValue();
            var values = [];
            var cnt = 0;
            
            for (var key in opts) {
                   cnt++;
            }
           
            if(cnt > 0)
            {
                component.set('v.hasCompany', true)
            }
            if(cnt == 1)
            {	
                var selectedValue = '';
                var selectedName = '';
                for (var key in opts) {
                    selectedValue = opts[key];
                    selectedName = key;
                }
                component.set('v.companyId', selectedValue);
                component.set('v.companyName', selectedName);
                component.set('v.isCompanySingle', true);
                
                picklistOptions['Facility_Options'] = null;
                component.set('v.picklists', picklistOptions);
                component.set('v.hasFacility', false);
                
                
                helper.getProgramCompanyFacility(component, helper);
           }else if (cnt > 1)
           {
                    values = [{label:'-- Please Select --',value:''}];
                    for (var key in opts) {
                        values.push({
                            label: key,
                            value: opts[key]
                        });
                    }
                     var picklistOptions = component.get('v.picklists');
            		 picklistOptions['Company_Options'] = values;
            		 component.set('v.picklists', picklistOptions);
           }
           component.set('v.showSpinner', false);
        });
        
        $A.enqueueAction(action);
    },
    
    
    getProgramCompanyFacility: function(component, helper){
        var action = component.get('c.getProgramCompanyFacility');
        var account = component.get('v.account');
        component.set('v.isFacilitySingle', false);
        component.set('v.hasFacility', false)
        action.setParams({
            programId :component.get('v.programId'),
            companyId: component.get('v.companyId')
        });
        
        action.setCallback(this, function(data){
            var opts = data.getReturnValue();
            var values = [];
            var cnt = 0;
            for (var key in opts) {
                   cnt++;
            }
			
            if(cnt > 0)
            {
                 component.set('v.hasFacility', true)
            }
            if(cnt == 1)
            {	
                    var selectedValue = '';
                    var selectedName = '';
                    for (var key in opts) {
                        selectedValue = opts[key];
                        selectedName = key;
                    }
                   	component.set('v.isFacilitySingle', true);
                	component.set('v.facilityId', selectedValue);
                	component.set('v.facilityName', selectedName);
                	
                
            }else if (cnt > 1)
            {
                values = [{label:'-- Please Select --',value:''}];
                for (var key in opts) {
                    values.push({
                        label: key,
                        value: opts[key]
                    });
                }
                
                var picklistOptions = component.get('v.picklists');
                picklistOptions['Facility_Options'] = values;
                component.set('v.picklists', picklistOptions);
            }

            component.set('v.showSpinner', false);
        }
        
        
        );
           
        $A.enqueueAction(action);
    },
    
 
    
    
    
    
    
    getProgramCustomizations: function(component, helper, programId){
        var action = component.get('c.getProgramProjectFieldCustomizations');
        action.setParams({
            programId:programId
        });
        action.setCallback(this, function(data){
            var fieldCustomizations = data.getReturnValue();
            console.log('fieldCustomizations', fieldCustomizations);
            component.set('v.fieldCustomizations', fieldCustomizations);
            
            
        });
        
        $A.enqueueAction(action);
    },
    selectKitToDiscard: function(component, helper){
        helper.toggleModal(component, 'DiscardKit');
    },
    
    initializeNewKit: function(component, helper){
        var action = component.get('c.initializeNewKit');
        action.setParams({
            programId:component.get('v.programId')
        });
        action.setCallback(this, function(data){
            var kit = data.getReturnValue();
            
            component.set('v.participantKit', kit);
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    initializeNewParticipant: function(component, helper){
        var action = component.get('c.initializeNewParticipant');
        var account = component.get('v.account');
        action.setParams({
            accountId: account.Id,
            programId: component.get('v.programId'),
            companyId: component.get('v.companyId'),
            facilityId: component.get('v.facilityId'),
            
            
        });
        
        action.setCallback(this, function(data){
            var participant = data.getReturnValue();
            participant.Participant__r.FirstName = component.get('v.participantSearchFirstName');
            participant.Participant__r.LastName = component.get('v.participantSearchLastName');
            participant.Participant__r.Employee_Id__c = component.get('v.participantSearchEmployeeId');
            participant.Participant__r.Birthdate = component.get('v.participantSearchDOB');
            participant.Participant__r.Email = component.get('v.participantSearchEmail');
            
            component.set('v.participant', participant);
            var input = component.find("participantFirstName");
            input.focus();
        });
        
        $A.enqueueAction(action);
        
    },
    
    getProgramParticipants: function(component, helper){
        var action = component.get('c.getProgramParticipants');
        var account = component.get('v.account');
        component.set('v.showSpinner', true);
        component.set('v.isSearchSuggestion', false);
        
        action.setParams({
            accountId: account.Id,
            programId: component.get('v.programId'),
            companyId: component.get('v.companyId'),
            facilityId: component.get('v.facilityId'),
            firstName: component.get('v.participantSearchFirstName'),
            lastName: component.get('v.participantSearchLastName'),
            employeeId: component.get('v.participantSearchEmployeeId'),
            dob: component.get('v.participantSearchDOB'),
            email: component.get('v.participantSearchEmail'),
            
        });
        
        action.setCallback(this, function(data){
            var participantList = data.getReturnValue();
            if(participantList == null || participantList.length == 0)
            {
                helper.getSuggestedProgramParticipants(component, helper);
                helper.getSuggestedContacts(component, helper);
                
            }else
            {
                component.set('v.participants', data.getReturnValue());
                component.set('v.showSpinner', false);
            }
            
        });
        
        $A.enqueueAction(action);
    },
      
    getSuggestedProgramParticipants: function(component, helper){
        var action = component.get('c.suggestProgramParticipants');
        var account = component.get('v.account');
        component.set('v.showSpinner', true);
        
        action.setParams({
            accountId: account.Id,
            firstName: component.get('v.participantSearchFirstName'),
            lastName: component.get('v.participantSearchLastName'),
            employeeId: component.get('v.participantSearchEmployeeId'),
            dob: component.get('v.participantSearchDOB'),
            email: component.get('v.participantSearchEmail'),
            
        });
        
        action.setCallback(this, function(data){
            var participantList = data.getReturnValue();
            if(participantList != null && participantList.length > 0)
            {
                component.set('v.isSearchSuggestion', true);
            }
            component.set('v.participants', data.getReturnValue());
            component.set('v.showSpinner', false);
            
        });
        
        $A.enqueueAction(action);
    },
    
    getSuggestedContacts: function(component, helper){
     var action = component.get('c.suggestContacts');
        var account = component.get('v.account');
        component.set('v.showSpinner', true);
        
        action.setParams({
            accountId: account.Id,
            firstName: component.get('v.participantSearchFirstName'),
            lastName: component.get('v.participantSearchLastName'),
            employeeId: component.get('v.participantSearchEmployeeId'),
            dob: component.get('v.participantSearchDOB'),
            email: component.get('v.participantSearchEmail'),
            
        });
        
        action.setCallback(this, function(data){
            var participantList = data.getReturnValue();
            if(participantList != null && participantList.length > 0)
            {
                component.set('v.isSearchSuggestion', true);
            }
            component.set('v.contacts', data.getReturnValue());
            component.set('v.showSpinner', false);
            
        });
        
        $A.enqueueAction(action);
    },
    
    getContactKits: function(component, helper){
      var action = component.get('c.getContactKits');
       var contact = component.get('v.contact');
        let errorMessages = [];
        
        component.set('v.showAlertError', false);          
        component.set('v.showSpinner', true);
        
        console.log('getting kits for contact = ' + contact.Id);
        
        action.setParams({
            contactId: contact.Id
        });   
        
         action.setCallback(this, function(data){
            
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                var participantKits = data.getReturnValue();
                
                component.set('v.participantKits', data.getReturnValue());
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    fetchData: function(component, fetchData){
        component.set('v.columns', [
            { label: 'Locator', fieldName: 'Name', type: 'text'},
            { label: 'Status', fieldName: 'Status__c', type: 'text'},
            { label: 'Ordered', fieldName: 'Date_Ordered__c', type: 'date'},
            { label: 'Resulted', fieldName: 'Date_Resulted__c', type: 'date'},
            { label: 'Entered By', fieldName: 'Entered_By__c', type: 'date'},
            { type: 'action', typeAttributes: {rowActions: rowActions}}
        ]);
        
        
        
        var action = component.get("c.getContactKits");
        action.setParams({
            participantId : participant
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.kitList",response.getReturnValue());
            }
        });
          
        var rowActions = helper.getRowActions.bind(this, component);
		
        $A.enqueueAction(action);
    },
    getRowIndex: function(rows,row){
       var rowIndex = -1;
        rows.some(function(current, i) {
            if(current.id === row.id) {
                rowIndex = i;
                return true;
            }
        });
        return rowIndex;
    },
    unpublishBook: function(cmp, row){
        var rows = cmp.get('v.rawData');
        var rowIndex = this.getRowIndex(rows, row);
        
        rows[rowIndex].Status__c = 'Discarded';
        this.updateBooks(cmp);
    },
    updateBooks: function(cmp){
        var rows = cmp.get('v.rawData');
        cmp.set('v.data', rows);
    },
    getRowActions: function (cmp, row, doneCallback){
        if(row.Status__c != 'Discarded'){
        var actions = [{
            'label': 'Mark Kit Discarded',
            'iconName': 'utility:ban',
            'name': 'discard'
        }];
        } else {
            var actions = [{
                'label': 'Unassign',
            	'iconName': 'utility:delete',
            	'name': 'remove'
            }];
        }
        
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    selectDiscardKit: function(component, helper){
        var action = component.get('c.getDataFromKit');
        var kit = component.get('v.selectedKitLocator');
        let errorMessages = [];
        
        component.set('v.showAlertError', false);
        component.set('v.showSpinner', true);
        
        action.setParams({
            kitlocatorId: kit.Id
        });
        
        action.setCallback(this, function(data){
            
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
            }
            
        });
    },
    
    getParticipantProgramKits: function(component, helper){
        var action = component.get('c.getParticipantProgramKits');
        var participant = component.get('v.participant');
        let errorMessages = [];
        
        component.set('v.showAlertError', false);          
        component.set('v.showSpinner', true);
        
        console.log('getting kits for participant = ' + participant.Id);
        
        action.setParams({
            participantProgramId: participant.Id
        });
        
        action.setCallback(this, function(data){
            
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                var participantKits = data.getReturnValue();
                
                component.set('v.participantKits', data.getReturnValue());
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    doSaveDiscardedKit: function(component, helper){
        var action = component.get('c.saveDiscardedKit');
        var selectedKit = component.get('v.selectedKitLocator');
        let errorMessages = [];
        component.set('v.showAlertError', false);
        component.set('v.showSpinner', true);
        
        action.setParams({
            kit: JSON.stringify(selectedKit)
        });

        console.log('discarding kit record = ' + selectedKit.Id);

        action.setCallback(this, function(data){
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    component.set('v.showSpinner', false);
                    component.set('v.showAlertError', true);
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
            } else{
                var dataResult = data.getReturnValue();
                if(dataResult.statusCode == 'OK'){
                    component.set('v.showSpinner',false);
                    helper.getParticipantProgramKits(component, helper);
                    helper.toggleModal(component, 'DiscardKit');
                }
                else{
                    component.set('v.showSpinner', false);
                    errorMessages.push({title: "Error", message: dataResult.errorMessage});
                    component.set('v.showAlertError', true);
                }
                
            }
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                //component.set('v.selectedKitLocator', null);
                
        });

        $A.enqueueAction(action);
    },

    resetKitList: function(component, helper){
        let errorMessages = [];
        
        
    },
    
    
    saveParticipant: function(component, helper){
        
        var action = component.get('c.saveProgramParticipant');
        var participant = component.get('v.participant');
        var participantKit = component.get('v.participantKit');
        var account = component.get('v.account');
        let errorMessages = [];
        component.set('v.showAlertError', false);          
        component.set('v.showSpinner', true);
        console.log('participant = ' + JSON.stringify(participant));
        console.log('participantkit = ' + JSON.stringify(participantKit));
        
        action.setParams({
            participant: JSON.stringify(participant),
            accountId: account.Id,
            programId: component.get('v.programId'),
            companyId: component.get('v.companyId'),
            facilityId: component.get('v.facilityId'),
            participantKit: JSON.stringify(participantKit)
        });
        
        
        action.setCallback(this, function(data){
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                var dataResult = data.getReturnValue();
                console.log('statuscode = ' + dataResult.statusCode);
                if( dataResult.statusCode == 'OK'){
                    component.set('v.participant', dataResult.dataRecord);
                    component.set('v.showSpinner', false);
                    var participantKit = component.get('v.participantKit');
                    helper.resetParticipantForm(component, helper);

                }else
                {
                    errorMessages.push({title: "Error", message: dataResult.errorMessage});
                    component.set('v.showAlertError', true);          
                }
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    
    resetParticipantForm: function(component, helper){
        let errorMessages = [];
        component.set('v.participant', null);
        component.set('v.participantKits', []);
        component.set('v.participantSearchFirstName', null);
        component.set('v.participantSearchLastName', null);
        component.set('v.participantSearchEmployeeId', null);
        component.set('v.participantSearchDOB', null);
        component.set('v.participantSearchEmail', null);
        component.set('v.participants', null);
        component.set('v.contacts', null);
        component.set('v.kitLocatorNotValid', false);
        component.set('v.errorMessages', errorMessages);
        component.set('v.isSearchSuggestion', false);
        component.set('v.kitLocatorNotValidMessage', null);
        component.set('v.kitLocatorReEnter', null);
        component.set('v.canEnrollNew', false);
        component.set('v.showAlertError', false);
        
        
        helper.initializeNewKit(component, helper);
        
        
        
    },
    isDiscardKitDataValue: function(component, helper){
        let errorMessages = [];
        component.set('v.showAlertError', false);
        var kit = component.get('v.selectedKitLocator');

        if(!kit.Discarded_Reason__c){
            errorMessages.push({title: "Required", message: 'Discarded Reason'});
        }
        if(!kit.Other_Discarded_Details__c && kit.Discarded_Reason__c == 'Other'){
            errorMessages.push({title: "Required", message: 'Other Discarded Details'});
        }
        component.set('v.errorMessages', errorMessages);
        component.set('v.showAlertError', errorMessages.length > 0);  
        return errorMessages.length == 0;
    },
    
    isParticipantDataValid: function(component, helper){
        let errorMessages = [];
        component.set('v.showAlertError', false);  
        var participant = component.get('v.participant');
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var birthDate = participant.Participant__r.Birthdate;
        var participantKit = component.get('v.participantKit');
        var fieldCustomizations = component.get('v.fieldCustomizations');
        var email = participant.Participant__r.Email;
        
        if(!participant.Participant__r.FirstName)
        {
            errorMessages.push({title: "Required", message: 'First Name'});
        }
        if(!participant.Participant__r.LastName)
        {
            errorMessages.push({title: "Required", message: 'Last Name'});
        }
        if(!participant.Participant__r.Gender__c)
        {
            errorMessages.push({title: "Required", message: 'Gender'});
        }
        if(!participant.Participant__r.Birthdate)
        {
            errorMessages.push({title: "Required", message: 'Birthdate'});
        }else if(birthDate > today)
        {
            errorMessages.push({title: "Error", message: 'Birthdate must be a current or past date'});            
        }
        if((!participant.Participant__r.Race__c || participant.Participant__r.Race__c == '') && 
           (!fieldCustomizations.Race  || fieldCustomizations.Race.isRequired == true))
        {
            var labelName = 'Race';
            if(fieldCustomizations.Race != null && fieldCustomizations.Race.altLabel != 'Race')
            {
                labelName = fieldCustomizations.Race.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.Ethnicity__c || participant.Participant__r.Ethnicity__c == '') && 
           (!fieldCustomizations.Ethnicity  || fieldCustomizations.Ethnicity.isRequired == true))
        {
            var labelName = 'Ethnicity';
            if(fieldCustomizations.Ethnicity != null && fieldCustomizations.Ethnicity.altLabel != 'Ethnicity')
            {
                labelName = fieldCustomizations.Ethnicity.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if(!participant.Participant__r.Employee_Id__c && 
           (fieldCustomizations.Participant_Id == null || fieldCustomizations.Participant_Id.isRequired == true))
        {
            var labelName = 'Participant Id';
            if(fieldCustomizations.Participant_Id != null && fieldCustomizations.Participant_Id.altLabel != 'Participant Id')
            {
                labelName = fieldCustomizations.Participant_Id.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.Employee_Type__c ||  participant.Participant__r.Employee_Type__c == '') && 
           (!fieldCustomizations.Participant_Type  || fieldCustomizations.Participant_Type.isRequired == true))
        {
            var labelName = 'Participant Type';
            if(fieldCustomizations.Participant_Type  && fieldCustomizations.Participant_Type.altLabel != 'Participant Type')
            {
                labelName = fieldCustomizations.Participant_Type.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.MailingStreet) && 
           (!fieldCustomizations.Street  || fieldCustomizations.Street.isRequired == true))
        {
            var labelName = 'Street';
            if(fieldCustomizations.Street != null && fieldCustomizations.Street.altLabel != 'Street')
            {
                labelName = fieldCustomizations.Street.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.MailingCity) && 
           (!fieldCustomizations.City  || fieldCustomizations.City.isRequired == true))
        {
            var labelName = 'City';
            if(fieldCustomizations.City != null && fieldCustomizations.City.altLabel != 'City')
            {
                labelName = fieldCustomizations.City.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.MailingState) && 
           (!fieldCustomizations.State  || fieldCustomizations.State.isRequired == true))
        {
            var labelName = 'State';
            if(fieldCustomizations.State != null && fieldCustomizations.City.altLabel != 'State')
            {
                labelName = fieldCustomizations.State.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if((!participant.Participant__r.MailingPostalCode) && 
           (!fieldCustomizations.Zip  || fieldCustomizations.Zip.isRequired == true))
        {
            var labelName = 'Zip Code';
            if(fieldCustomizations.Zip != null && fieldCustomizations.City.altLabel != 'Zip Code')
            {
                labelName = fieldCustomizations.Zip.altLabel;
            }
            errorMessages.push({title: "Required", message: labelName});
        }
        if(participantKit.Id == null || component.get('v.kitLocatorNotValid') == true)
        {
            errorMessages.push({title: "Required", message: "Kit Locator"});
        }
        else if(participantKit.Id != null && participantKit.Name != null && component.get('v.kitLocatorNotValid') == false)
        {
            if(participantKit.Name == null)
            {
                errorMessages.push({title: "Required", message: 'Kit Locator'});
            }
            
            if((!participantKit.Reason_for_Testing__c ||  participantKit.Reason_for_Testing__c == '') && 
               (!fieldCustomizations.Reason_for_Testing  || fieldCustomizations.Reason_for_Testing.isRequired == true))
            {
                var labelName = 'Reason for Testing';
                if(fieldCustomizations.Reason_for_Testing  && fieldCustomizations.Reason_for_Testing.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Reason_for_Testing.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            
            if((!participantKit.Symptoms_Present__c ||  participantKit.Symptoms_Present__c == '') && 
               (!fieldCustomizations.Condition  || fieldCustomizations.Condition.isRequired == true))
            {
                var labelName = 'Condition';
                if(fieldCustomizations.Condition  && fieldCustomizations.Condition.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Condition.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            
            if((!participantKit.Collection_Date_Time__c) && 
               (!fieldCustomizations.Collection_Date  || fieldCustomizations.Collection_Date.isRequired == true))
            {
                var labelName = 'Collection Date';
                if(fieldCustomizations.Collection_Date  && fieldCustomizations.Collection_Date.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Collection_Date.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            
            if((!participantKit.Approving_Provider__c ||  participantKit.Approving_Provider__c == '') && 
               (!fieldCustomizations.Approving_Provider  || fieldCustomizations.Approving_Provider.isRequired == true))
            {
                var labelName = 'Approving Provider';
                if(fieldCustomizations.Approving_Provider  && fieldCustomizations.Approving_Provider.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Approving_Provider.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            
            
            if((!participantKit.Tempurature__c) && (!fieldCustomizations.Temperature  || fieldCustomizations.Temperature.isRequired == true))
            {
                var labelName = 'Temperature';
                if(fieldCustomizations.Temperature  && fieldCustomizations.Temperature.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Temperature.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }else if(participantKit.Tempurature__c != null)
            {
                var temp = participantKit.Tempurature__c;
                console.log('temp = ' + temp);
                if(temp.indexOf('.') > -1)
                {
                    var arrTemp = temp.split('.')
                    {
                        
                        if (arrTemp[1].length != 1 || arrTemp[0].length > 3)
                        {
                            errorMessages.push({title: "Format", message: 'Please enter a valid temperature with one decimal place (ex: 100.2)'});
                        }
                    }
                }else
                {
                    if(temp.length > 3)
                    {
                        errorMessages.push({title: "Format", message: 'Please enter a valid temperature with one decimal place (ex: 100.2)'});
                    }
                }
            }
            
            
            if((participantKit.Patient_Consent__c == null || participantKit.Patient_Consent__c == false) && 
               (!fieldCustomizations.Patient_Consent  || fieldCustomizations.Patient_Consent.isRequired == true))
            {
                var labelName = 'Patient Consent';
                if(fieldCustomizations.Patient_Consent__c  && fieldCustomizations.Patient_Consent__c.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Patient_Consent__c.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            
            if((participantKit.Photo_ID_Verified__c == null || participantKit.Photo_ID_Verified__c == false) && 
               (!fieldCustomizations.Photo_ID_Verified  || fieldCustomizations.Photo_ID_Verified.isRequired == true))
            {
                var labelName = 'Photo ID Verified';
                if(fieldCustomizations.Photo_ID_Verified  && fieldCustomizations.Photo_ID_Verified.altLabel != labelName)
                {
                    labelName = fieldCustomizations.Photo_ID_Verified.altLabel;
                }
                errorMessages.push({title: "Required", message: labelName});
            }
            
            var locatorNumberNotValid = component.get('v.kitLocatorNotValid');
            if(locatorNumberNotValid == true)
            {
                errorMessages.push({title: "Required", message: 'Valid Kit Locator'});
            } 
        } 
        
        component.set('v.errorMessages', errorMessages);
        component.set('v.showAlertError', errorMessages.length > 0);  
        return errorMessages.length == 0;
        
    },
    
    discardKit: function(component, helper, participantKitLocator){
        var action = component.get('c.discardKit');
        let errorMessages = [];
        component.set('v.showAlertError', false);          
        component.set('v.showSpinner', true);
        
        action.setParams({
            participantKit: participantKitLocator
            
        });
        
        action.setCallback(this, function(data){
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                var dataResult = data.getReturnValue();
                if( dataResult.statusCode == 'OK'){
                    
                    
                }else
                {
                    component.set('v.showSpinner', false);
                    errorMessages.push({title: "Error", message: dataResult.errorMessage});
                    component.set('v.showAlertError', true);          
                }
                
            }
            
            component.set('v.errorMessages', errorMessages);
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    removeParticipantKit: function(component, helper, participantKitLocator){
        var action = component.get('c.removeParticipantKit');
        let errorMessages = [];
        component.set('v.showAlertError', false);          
        component.set('v.showSpinner', true);
        
        action.setParams({
            participantKit: participantKitLocator
            
        });
        
        action.setCallback(this, function(data){
            var state = data.getState();
            console.log('state = ' + state);
            if(state == 'ERROR')
            {
                let errors = data.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.log(message);
                errorMessages.push({title: "Error", message: message});
                component.set('v.showAlertError', true);   
                component.set('v.showSpinner', false);
                component.set('v.errorMessages', errorMessages);
                
                
            }else
            {
                var dataResult = data.getReturnValue();
                if( dataResult.statusCode == 'OK'){
                    
                    helper.getParticipantProgramKits(component, helper);
                    
                    
                }else
                {
                    component.set('v.showSpinner', false);
                    errorMessages.push({title: "Error", message: dataResult.errorMessage});
                    component.set('v.showAlertError', true);          
                }
                
            }
            
            component.set('v.errorMessages', errorMessages);
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    searchKit: function(component, helper){
        var action = component.get('c.searchKit'); 
        var account = component.get('v.account');
        component.set('v.kitQuickSearchNotValid', false); 
        console.log('kitSearchName = ' + component.get('v.kitSearchName'));  
        action.setParams({
            kitLocator: component.get('v.kitSearchName'),
            accountId: account.Id
        });
        
        action.setCallback(this, function(data){
            var kitResult = data.getReturnValue();
            console.log('kitResult = ' + kitResult);
            if(kitResult == null)
            {
                component.set('v.kitQuickSearchNotValid', true);     
            }else
            {
                
                component.set('v.kitLocator', kitResult);
                helper.toggleModal(component, 'Kit');
            }
            
            
            
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    
    checkValidParticipantKit: function(component, helper, kitLocator){
        var action = component.get('c.checkValidParticipantKit');       
        component.set('v.kitLocatorNotValid', false);   
        component.set('v.kitLocatorNotValidMessage', null);   
        
        
        if(kitLocator == null || kitLocator == '')
        {
            return;
        }
        
        action.setParams({
            kitLocator: kitLocator,
            programId: component.get('v.programId')
        });
        
        action.setCallback(this, function(data){
            var kitId = data.getReturnValue();
            console.log('kitid = ' + kitId);
            if(kitId == null)
            {
                component.set('v.kitLocatorNotValid', true);     
                component.set('v.kitLocatorNotValidMessage', 'Not a valid kit locator.  Please check your entry.');   
            }
            else
            {
                var participantKit = component.get('v.participantKit');
                participantKit.Id = kitId;
                component.set('v.participantKit', participantKit);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    
    
    
    
    fetchPicklistValues: function(component, sObjectAPIName, fieldAPIName, includeSelect){
        var picklistAction = component.get('c.getPicklistValues');
        picklistAction.setParams({
            sObjectAPIName: sObjectAPIName,
            picklistName: fieldAPIName
        });
        
        picklistAction.setCallback(this, function(picklistReturn){
            var opts = picklistReturn.getReturnValue();
            var values = [];
            if(includeSelect)
            {
                values = [{label:'-- Please Select --',value:''}];
            }
            
            for (var option in opts) {
                values.push({
                    label: option,
                    value: option
                });
            }
            
            var picklistOptions = component.get('v.picklists');
            picklistOptions[fieldAPIName] = values;
            component.set('v.picklists', picklistOptions);
        });
        
        $A.enqueueAction(picklistAction);
    },
    
    
    
})