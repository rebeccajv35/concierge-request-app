public with sharing class ParticipantKitQuickController {
    
    @AuraEnabled
    public static Map<String, String> getPicklistValues(String sObjectAPIName, String picklistName) {
        return LightningUtil.getPicklistValues(sObjectAPIName, picklistName);
    }
    
     @AuraEnabled
    public static  Map<String, CustomizedField> getProgramProjectFieldCustomizations(String programId) {
        SYSTEM.DEBUG('Programid = ' + programid);
        Map<String, CustomizedField> customFieldmap = new Map<String, CustomizedField>();
        
        List<Program_Project_Field_Customization__c>  programCustomizations = [SELECT Id, 
                                                                               Required__c,
                                                                               Visible__c,
                                                                               Read_Only__c,
                                                                               Alternate_Label__c,
                                                                               Section__c, 
                                                                               Program_Project__c, 
                                                                               Field__c
                                                                               FROM Program_Project_Field_Customization__c
                                                                               WHERE Program_Project__c=: programId
                                                                              AND Field__c != null];
        
        for(Program_Project_Field_Customization__c field : programCustomizations)
        {
            CustomizedField cf = new CustomizedField();
            cf.isRequired = field.Required__c;
            cf.isVisible = field.Visible__c;
            cf.isDisabled = field.Read_Only__c;
            cf.altLabel = field.Alternate_Label__c;
            if(cf.altLabel == null || cf.altLabel.trim() == '')
            {
                cf.altLabel = field.Field__c;
            }
            String fieldName= field.Field__c.replaceAll(' ', '_');
           
            customFieldMap.put(fieldName, cf);
        }
        
        return customFieldMap;
        
    }
    
    @AuraEnabled
    public static Boolean isPortalUser() {
        Profile profile = [Select Id, Name from Profile where Id=: UserInfo.getProfileId()];
        return profile.Name == 'Customer Community Plus User';

    }
    
    
    @AuraEnabled
    public static Account getAccountInformation(String accountId) {

        if(accountId == null || accountId == '')
        {
            Profile profile = [Select Id, Name from Profile where Id=: UserInfo.getProfileId()];
            User user = [Select Customer__c from User where Id=: UserInfo.getUserId()].get(0);
            string customer = user.Customer__c;
            Id contactId = [SELECT contactId 
            FROM User 
            WHERE id =: Userinfo.getUserid()].contactId;

            accountId  = [SELECT AccountId 
            FROM Contact 
            WHERE Id =: contactid].AccountId;
        }
       
        
           
            List<Account> accountList = [SELECT Id, Name 
                                         FROM Account 
                                         WHERE Id=:accountId];
            return accountList.get(0);
        
        
        
        
    }
    
    @AuraEnabled
    public static List<Program_Project__c> getAccountActivePrograms(Id accountId) {
     	
        List<Program_Project__c> accountPrograms = [SELECT Id, 
                                                    Name,
                                                    Program_Name__c,
                                                    Kit_Type__c 
                                                    FROM Program_Project__c 
                                                    WHERE Account__c =: accountId 
                                                    AND Program_Status__c = 'Active'];
        return accountPrograms;
        
    }
    
    @AuraEnabled
    public static User getCurrentUserInfo() {
        User userInfo = [Select Id, NPI_Number__c, Name, Profile.Name from User where Id=: UserInfo.getUserId()];
        return userInfo;
            
    }
    
    public static List<Account> getAvailableAccounts () {
         List<Account> accountList = [Select Id, Name from Account 
                                          where Id in
                                         (Select Account__c FROM Program_Project__c WHERE Salesforce_Community__c = true and Program_Status__c = 'Active')];
        if(accountList.size() == 0)
            {
                accountList = [Select Id, Name from Account];
            }
        return accountList;    
    }

    @AuraEnabled
    public static Map<String, String> getApprovingProviders(Id programId) {
        Map<String, String> providerMap = new Map<String, String>();
        User userInfo = [Select Id, NPI_Number__c, FirstName, LastName from User where Id=: UserInfo.getUserId()];
        List<Physician__c> userPhysician = new List<Physician__c>();
              
        
        if(userInfo.NPI_Number__c != null)
        {
            userPhysician = [Select Id, Name, First_Name__c, Last_Name__c from Physician__c where NPI__c =: userInfo.NPI_Number__c and Program_Project__c =: programId];
            if(userPhysician.size() == 0)
            {
                Physician__c physician = new Physician__c();
                physician.First_Name__c = userInfo.FirstName;
                physician.Last_Name__c = userInfo.LastName;
                physician.NPI__c = userInfo.NPI_Number__c;
                physician.Program_Project__c = programId;
                insert physician;
              
          
                
            }
        }
        
        List<Physician__c> physicians = [SELECT Id, 
                                                    Name,
                                         			First_Name__c,
                                         			Last_Name__c
                                                    From Physician__c 
                                         			WHERE Program_Project__c =:programId Order By Name ASC];
        
        
        
        if(userPhysician.size() > 0)
        {
            physicians.add(userPhysician.get(0));
        }
        for(Physician__c p : physicians)
        {
            if(providerMap.get(p.Id) == null)
            {
                string physicianName = p.First_Name__c + ' ' + p.Last_Name__c;
                providerMap.put(physicianName.toUpperCase(), p.Id);
            }
        }
        
     
        return providerMap;
        
    }
    
    @AuraEnabled
    public static Map<String, String> getActivePrograms(Id accountId) {
        Map<String, String> programMap = new Map<String, String>();
        
        List<Program_Project__c> accountPrograms = [Select 
                                                    Id,
                                                    Name,
                                                    Program_Name__c 
                                                    FROM Program_Project__c 
                                                    WHERE (Program_Status__c = 'Active' OR Program_Status__c = 'Launched')
                                                    AND Account__c =: accountId
                                                    AND Salesforce_Community__c = true
                                                    Order By Program_Name__c ASC];
        
        for(Program_Project__c p : accountPrograms)
        {
            if(programMap.get(p.Id) == null)
            {
                programMap.put(p.Program_Name__c.toUpperCase(), p.Id);
            }
        }
        
        return programMap;
        
    }
    
    @AuraEnabled
    public static List<Kit_Locator__c> getParticipantProgramKits(String participantProgramId) {
        SYSTEM.DEBUG('PARTICIPANTPROGRAMID = ' + participantProgramId);
        
        if(participantProgramId != null && participantProgramId != '')
        {
            List<Kit_Locator__c> kitList = [SELECT 
                                            Id,
                                            Date_Ordered__c,
                                            Date_Resulted__c,
                                            Downloaded__c,
                                            Locked__c,
                                            Kit_ID_Ext_ID__c,
                                            Entered_By__c,
                                            LastModifiedDate,
                                            Name,
                                            Collection_Date_Time__c,
                                            Patient_Consent__c,
                                            Program_Participant__c,
                                            Program__c,
                                            Reason_for_Testing__c,
                                            Status__c,
                                            Symptoms_Present__c,
                                            Approving_Provider__c,
                                            Tempurature__c,
                                            Photo_ID_Verified__c,
                                            Result_Value__c
                                            FROM Kit_Locator__c
                                            WHERE Program_Participant__c =: participantProgramId
                                           ORDER BY Collection_Date_Time__c ASC];
            
            return kitList;
        }else
        {
            return new List<Kit_Locator__c>();
        }
        
    }
        
    @AuraEnabled
    public static List<Kit_Locator__c> getContactKits(String participantId){
        Program_Participant__c pp = [SELECT Participant__r.Id FROM Program_Participant__c WHERE Id =: participantId][0];
        string contactId = pp.Participant__c;
        
        if(contactId != null && contactId != '')
        {
            List<Kit_Locator__c> kitList = [SELECT 
                                            Id,
                                            Date_Ordered__c,
                                            Date_Resulted__c,
                                            Downloaded__c,
                                            Locked__c,
                                            Kit_ID_Ext_ID__c,
                                            Entered_By__c,
                                            LastModifiedDate,
                                            Name,
                                            Collection_Date_Time__c,
                                            Patient_Consent__c,
                                            Program_Participant__c,
                                            Program__c,
                                            Reason_for_Testing__c,
                                            Status__c,
                                            Symptoms_Present__c,
                                            Approving_Provider__c,
                                            Tempurature__c,
                                            Photo_ID_Verified__c,
                                            Program_Participant__r.Account_Company__r.Name,
                                            Program_Participant__r.Program__r.Name
                                            FROM Kit_Locator__c
                                            WHERE Program_Participant__r.Participant__c =: contactId
                                           ORDER BY Collection_Date_Time__c ASC LIMIT 10];
            
            return kitList;
        }else
        {
            return new List<Kit_Locator__c>();
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getAccountProgramCompanies(Id programId) {
        
        Map<String, String> companyMap = new Map<String, String>();
        
        List<Program_Participant__c> programParticipantList = [SELECT Account_Company__c, 
                                                               Account_Company__r.Name
                                                               FROM Program_Participant__c 
                                                               WHERE Program__c =:programId
                                                               and Account_Company__r.Active__c = true
                                                               Order By Account_Company__r.Name ASC];
        
        List<Account_Company__c> accountCompanyList = [SELECT Id, Name
                                                       FROM Account_Company__c
                                                       WHERE Program_Project__c =:programId
                                                       and Active__c = true
                                                       Order By Name ASC];
        
       /* for(Program_Participant__c p : programParticipantList)
        {
            if(companyMap.get(p.Id) == null)
            {
                companyMap.put(p.Account_Company__r.Name, p.Account_Company__c);
            }
        } */
        
        for(Account_Company__c ac : accountCompanyList)
        {
            if(companymap.get(ac.Id) == null)
            {
                companyMap.put(ac.Name, ac.Id);
            }
        }
        
        return companyMap; 
    }
    
    @AuraEnabled
    public static Map<String, String> getProgramCompanyFacility(Id programId,  Id companyId) {
        
        Map<String, String> facilityMap = new Map<String, String>();
        
        
       /* List<Program_Participant__c> programParticipantList = [SELECT Company_Facility__c, Company_Facility__r.Name
                                                               FROM Program_Participant__c 
                                                               WHERE Program__c =: programId
                                                               AND Account_Company__c =: companyId
                                                               Order By Company_Facility__r.ExternalId__c ASC];
*/
      List<Company_Facility__c> LocationList = [SELECT Id, Name
                                                       FROM Company_Facility__c
                                                       WHERE Account_Company__c =: companyId
                                                       Order By ExternalId__c ASC];
       
        
        for(Company_Facility__c p : LocationList)
        {
            if(facilityMap.get(p.Id) == null)
            {
                facilityMap.put(p.Name, p.Id);
            }
        }
        
        
        return facilityMap;
      //  System.Debug('facilityMap = ' + facilityMap);
        
        
    }

    @AuraEnabled
    public static LTsObjectResult saveDiscardedKit(Kit_Locator__c kit){
        Savepoint sp = Database.setSavepoint();
        LTsObjectResult saveResult = new LTsObjectResult();
        SYSTEM.DEBUG('kit JSON = ' + kit);
        try {
            kit.Status__c = 'Discarded';
            update kit;
            saveResult.statusCode = 'OK';
            saveResult.dataRecord = new Kit_Locator__c();  

        } catch (Exception e) {
            Database.rollback(sp);
            saveResult.errorMessage = e.getMessage() + e.getStackTraceString();
            saveResult.statusCode = 'ERROR';
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            
        }
        return saveResult;
    }
    
    @AuraEnabled
    public static LTsObjectResult saveProgramParticipant(String  participant, Id accountId, Id programId, Id companyId, Id facilityId, String participantKit)
    {
        Savepoint sp = Database.setSavepoint();
        LTsObjectResult saveResult = new LTsObjectResult();
        SYSTEM.DEBUG('participant JSON = ' + participant);
        try
        {
            Program_Participant__c p = (Program_Participant__c) System.JSON.deserialize(participant, Program_Participant__c.Class);
            if(p.Participant__r.PII_Update__c == false && p.Participant__c != null)
            { 
                //do not overwrite PII update if they didn't do it this time
                Contact c = [Select Id, PII_Update__c from Contact where Id=: p.Participant__c];
                if(c.PII_Update__c == true)
                {
                    p.Participant__r.PII_Update__c = true;
                }
            }
            Contact c = p.Participant__r;
            upsert c;
            
            Id participantProgramId = p.Id;
            if(p.Id == null || p.Program__c != programId || p.Account_Company__c != companyId || p.Company_Facility__c != facilityId)
            {
                Program_Participant__c newProgramParticipant = new Program_Participant__c();
                newProgramParticipant.Account_Company__c = companyId;
                newProgramParticipant.Company_Facility__c = facilityId;
                newProgramParticipant.Program__c = programId;
                newProgramParticipant.Participant__c = c.Id;
                newProgramParticipant.Status__c = 'Enrolled';
                insert newProgramParticipant;
                participantProgramId = newProgramParticipant.Id;
            }else
            {
                p.Status__c = 'Enrolled';
       			update p;
            }
          
            
           
            SYSTEM.DEBUG('SAVED OK');
            
            if(participantKit != null && participantKit != '')
            {
                Kit_Locator__c kit = (Kit_Locator__c) System.JSON.deserialize(participantKit, Kit_Locator__c.Class);
                if(kit.Id != null)
                {
                    kit.Date_Ordered__c = date.today();
                    kit.Status__c = 'Reserved';
                    kit.Program_Participant__c = participantProgramId;
                    update kit;
                }
            }
            
            saveResult.statusCode = 'OK';
            saveResult.dataRecord = p;
            
        }catch(Exception ex)
        {
            Database.rollback(sp);
            saveResult.errorMessage = ex.getMessage() + ex.getStackTraceString();
            saveResult.statusCode = 'ERROR';
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
        
        return saveResult;
        
    }
    
    @AuraEnabled
    public static Program_Participant__c initializeNewParticipant(Id accountId, Id programId, Id companyId, Id facilityId)
    {
        Program_Participant__c programParticipant = new Program_Participant__c();
        
        Contact c = new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Participant').getRecordTypeId();
        c.FirstName = '';
        c.LastName = '';
        
        
        programParticipant.Participant__r = c;
        programParticipant.Account_Company__c = companyId;
        programParticipant.Company_Facility__c = facilityId;
        programParticipant.Program__c = programId;
        programParticipant.Status__c = 'Enrolled';
        
        return programParticipant;
        
    }
    
    @AuraEnabled
    public static Kit_Locator__c initializeNewKit(String programId)
    {
        User userInfo = [Select Id, NPI_Number__c, Name from User where Id=: UserInfo.getUserId()];
        Kit_Locator__c kit = new Kit_Locator__c();
        if(userInfo.NPI_Number__c != null)
        {
            List<Physician__c> physicianList = [Select Id FROM Physician__c WHERE NPI__c =: userInfo.NPI_Number__c AND Program_Project__c=:programId];
            if(physicianList.size() > 0)
            {
                kit.Approving_Provider__c = physicianList.get(0).Id;
            }
            
        }
       
        kit.Collection_Date_Time__c = system.now();
        
        
   
        return kit;
        
    }
    
    @AuraEnabled
    public static List<Program_Participant__c> getProgramParticipants(Id accountId, String programId, String companyId, String facilityId, String firstName, String lastName, String employeeId, Date dob, String email) {
        List<Program_Participant__c> programParticipantList = new List<Program_Participant__c>();
        SYSTEM.DEBUG('programid = ' + programId);
        SYSTEM.DEBUG('companyId = ' + companyId);
        SYSTEM.DEBUG('facilityId = ' + facilityId);
        try
        {
            String query = 'SELECT Id, Name,Program__c,Program_Name__c, Program__r.Name,Account_Company__c, Account_Company__r.Name, Company_Facility__c,  Company_Facility__r.Name, Participant__c, Participant__r.MobilePhone, Participant__r.Email, Participant__r.Phone, Participant__r.FirstName,Participant__r.Gender__c,  Participant__r.LastName, Participant__r.BirthDate, Participant__r.MailingStreet, Participant__r.MailingCity, Participant__r.MailingState, Participant__r.MailingPostalCode, Participant__r.Employee_Id__c, Participant__r.Race__c, Participant__r.Ethnicity__c, Participant__r.Employee_Type__c, Status__c FROM Program_Participant__c';
            query += ' WHERE (Status__c = \'Enrolled\' OR Status__c = \'Eligible\')';
            query += ' AND Program__r.Account__c = : accountId ';
           /* RJV 2021-10-14 removing the restriction of results only within the same program, group and sub-group */
            query += ' AND Program__c = : programId ';
            if(companyId != null && companyId != '')
            {
                 query += ' AND Account_Company__c = : companyId ';
            }
            /*if(facilityId != null && facilityId != '')
            {
                 query += ' AND Company_Facility__c = : facilityId ';
            }*/
            if(firstName != null && firstName.trim() != '')
            {
                query += ' AND Participant__r.FirstName like \'' + firstName.trim() + '%\'';
            }
            if(lastName != null && lastName.trim() != '')
            {
                query += ' AND Participant__r.LastName like \'' + lastName.trim() + '%\'';
            }
            if(employeeId != null && employeeId.trim() != '')
            {
                query += ' AND Participant__r.Employee_Id__c = \'' + employeeId.trim() + '\'';
            }
            if(dob != null)
            {
                query += ' AND Participant__r.Birthdate =: dob';
            }
            if(email != null)
            {
                query += ' AND Participant__r.Email =: email';
            }
            query += ' Order By Participant__r.LastName ASC';
            SYSTEM.DEBUG('query= ' + query);
            
            programParticipantList = (List<Program_Participant__c>)Database.query(query);
            
            
        }catch(Exception ex)
        {
            System.debug(ex.getMessage() + ex.getStackTraceString());
        }
        return programParticipantList;
        
        
    }
       
@AuraEnabled                                                         
    public static List<Program_Participant__c> suggestProgramParticipants(Id accountId, String programId, String companyId, String facilityId, String firstName, String lastName, String employeeId, Date dob, String email) {
        List<Program_Participant__c> programParticipantList = new List<Program_Participant__c>();
        SYSTEM.DEBUG('programid = ' + programId);
        SYSTEM.DEBUG('companyId = ' + companyId);
        SYSTEM.DEBUG('facilityId = ' + facilityId);
        try
        {
            String query = 'SELECT Id, Name, Program__r.Name,Program_Name__c, Account_Company__r.Name, Company_Facility__r.Name, Participant__c, Participant__r.MobilePhone, Participant__r.Phone, Participant__r.Email, Participant__r.FirstName,Participant__r.Gender__c,  Participant__r.LastName, Participant__r.BirthDate, Participant__r.MailingStreet, Participant__r.MailingCity, Participant__r.MailingState, Participant__r.MailingPostalCode, Participant__r.Employee_Id__c, Status__c,Participant__r.Race__c, Participant__r.Ethnicity__c, Participant__r.Employee_Type__c, Participant__r.PII_Update__c FROM Program_Participant__c';
            query += ' WHERE (Status__c = \'Enrolled\' OR Status__c = \'Eligible\')';
            query += ' AND Program__r.Account__c = : accountId ';
           if(firstName != null && firstName.trim() != '')
            {
                query += ' AND Participant__r.FirstName like \'' + firstName.trim() + '%\'';
            }
            if(lastName != null && lastName.trim() != '')
            {
                query += ' AND Participant__r.LastName like \'' + lastName.trim() + '%\'';
            }
            if(employeeId != null && employeeId.trim() != '')
            {
                query += ' AND Participant__r.Employee_Id__c = \'' + employeeId.trim() + '\'';
            }
            if(dob != null)
            {
                query += ' AND Participant__r.Birthdate =: dob';
            }
            if(email != null)
            {
                query += ' AND Participant__r.Email =: email';
            }
            query += ' Order By Participant__r.LastName, Participant__r.Email ASC';
            
            
            SYSTEM.DEBUG('query= ' + query);
            
            programParticipantList = (List<Program_Participant__c>)Database.query(query);
            SYSTEM.DEBUG('results found ' + programParticipantList.size());
            
            
        }catch(Exception ex)
        {
            System.debug(ex.getMessage() + ex.getStackTraceString());
        }
        return programParticipantList;
    }
    
    @AuraEnabled
    public static List<Contact> suggestContacts(Id accountId, String firstName, String lastName, String employeeId, Date dob, String email){
        SYSTEM.DEBUG('accountid = ' + accountId);
        SYSTEM.DEBUG('firstName = ' + firstName);
        SYSTEM.DEBUG('lastName = ' + lastName);
         SYSTEM.DEBUG('employeeId = ' + employeeId);
        SYSTEM.DEBUG('dob = ' + dob);
        SYSTEM.DEBUG('email = ' + email);
        List<Contact> suggestContactList = new List<Contact>();
        try{
            String query = 'SELECT Id, lastName, firstName, mobilePhone, phone, email, gender__c, birthdate, mailingstreet, mailingcity, mailingstate, mailingpostalcode, employee_id__c, race__c, ethnicity__c, employee_type__c FROM Contact';
           // query += ' WHERE Id in (SELECT Participant__c FROM Program_Participant__c WHERE Program__r.Account__c =: accountId) ';
            query += ' WHERE Member_UUID__c != \'\' ';
            if(firstName != null){
                query += ' AND firstName like \'' + firstName.trim() + '%\'';
            }
            if(lastName != null){
                query += ' AND lastName like \'' + lastName.trim() + '%\'';
            }
            if(employeeId != null && employeeId.trim() != '')
            {
                query += ' AND Employee_Id__c = \'' + employeeId.trim() + '\'';
            }
            if(dob != null)
            {
                query += ' AND Birthdate =: dob';
            }
            if(email != null)
            {
                query += ' AND Email =: email';
            }
            // query += ' Order By LastName ASC';
            SYSTEM.DEBUG('query= ' + query);
            
            suggestContactList = (List<Contact>)Database.query(query);
             SYSTEM.DEBUG('results found ' + suggestContactList.size());
        }
        catch(Exception ex){
            System.debug(ex.getMessage() + ex.getStackTraceString());
        }
        return suggestContactList;
       
    }
    /*
    @AuraEnabled
    public static List<Program_Participant__c> suggestProgramParticipants(Id accountId, Id programId, Id companyId, Id facilityId,String firstName, String lastName, String employeeId, Date dob) {
        
        Set<Id> contactSet = new Set<Id>();
        
        List<Program_Participant__c> programParticipantList = getProgramParticipantsNoLocation(accountId, programId, firstName, lastName, employeeId, dob); 
        
        if(programParticipantList.size() == 0)
        {
            
            
            String query = 'SELECT Id, FirstName, LastName, Gender__c,BirthDate,MailingStreet,MailingCity,MailingState,MailingPostalCode, Employee_Id__c,Race__c, Ethnicity__c, Employee_Type__c, PII_Update__c FROM Contact WHERE RecordType.Name =\'Participant\' ';
            if(firstName != null && firstName.trim() != '')
            {
                query += ' AND FirstName like \'%' + firstName.trim() + '%\'';
            }
            if(lastName != null && lastName.trim() != '')
            {
                query += ' AND LastName like \'%' + lastName.trim() + '%\'';
            }
            if(employeeId != null && employeeId.trim() != '')
            {
                employeeId += ' AND Employee_Id__c = \'%' + employeeId.trim() + '%\'';
            }
            
            List<Contact> suggestedContactList = (List<Contact>)Database.query(query);
            if(suggestedContactList.size() > 0)
            {
                for(Contact c : suggestedContactList)
                {
                    Program_Participant__c participantProgram = new Program_Participant__c();
                    participantProgram.Program__c = programId;
                    participantProgram.Participant__c = c.Id;
                    participantProgram.Participant__r = c;
                    programParticipantList.add(participantProgram);
                    
                }
            }
        }
        
        return programParticipantList;
        
    }
*/
    
    @AuraEnabled
    public static Id checkValidParticipantKit(String kitLocator, String programId) {
        List<Kit_Locator__c> kitList = [Select Id from Kit_Locator__c where Status__c = null AND Name=: kitLocator AND Program__c=: programId];
        SYSTEM.DEBUG('kitlist size = ' + kitList.size());
        if(kitList.size() > 0)
        {
            return kitList.get(0).Id;
        }
        return null;
        
    }
    
    @AuraEnabled
    public static Kit_Locator__c searchKit(String kitLocator, String accountId) {
        List<Kit_Locator__c> kitList = [SELECT 
                                        Id,
                                        Date_Ordered__c,
                                        Date_Resulted__c,
                                        Downloaded__c,
                                        Collection_Date_Time__c,
                                        Kit_ID_Ext_ID__c,
                                        Entered_By__c,
                                        LastModifiedBy.Name,
                                        LastModifiedBy.Email,
                                        LastModifiedBy.CommunityNickname,
                                        LastModifiedDate,
                                        Name,
                                        Program_Participant__c,
                                        Program_Participant__r.Participant__r.FirstName,
                                        Program_Participant__r.Participant__r.LastName,
                                        Program_Participant__r.Participant__r.Employee_Id__c,
                                        Program_Participant__r.Participant__r.MailingStreet,
                                        Program_Participant__r.Participant__r.MailingCity,
                                        Program_Participant__r.Participant__r.MailingState,
                                        Program_Participant__r.Participant__r.MailingPostalCode,
                                        Program_Participant__r.Participant__r.Birthdate,
                                        Program_Participant__r.Participant__r.Race__c,
                                        Program_Participant__r.Participant__r.Ethnicity__c,
                                        Program_Participant__r.Participant__r.Employee_Type__c,
                                        Program_Participant__r.Participant__r.Phone,
                                        Program_Participant__r.Participant__r.MobilePhone,
                                        Program_Participant__r.Participant__r.Email,
                                        Program_Participant__r.Participant__r.PII_Update__c,
                                        Program_Participant__r.Account_Company__r.Name,
                                        Program_Participant__r.Company_Facility__r.Name,
                                        Program_Participant__r.Program__r.Name,
                                        Program_Participant__r.Program__r.Program_Name__c,
                                        Program_Participant__r.Status__c,
                                        Patient_Consent__c,
                                        Process_Immediately__c,
                                        Reason_for_Testing__c,
                                        Status__c,
                                        Symptoms_Present__c,
                                        Tempurature__c 
                                        FROM Kit_Locator__c
                                        WHERE Program_Participant__r.Program__r.Account__c=: accountId
                                        AND Name =: kitLocator];
        if(kitList.size() > 0)
        {
            return kitList.get(0);
        }
        return null;
        
    }
      
    @AuraEnabled
    public static LTsObjectResult saveParticipantKit(String participantKit, Id participantProgramId) {
        Savepoint sp = Database.setSavepoint();
        LTsObjectResult saveResult = new LTsObjectResult();
        try
        {
            Kit_Locator__c kit = (Kit_Locator__c) System.JSON.deserialize(participantKit, Kit_Locator__c.Class);
            kit.Date_Ordered__c = date.today();
            kit.Status__c = 'Reserved';
            kit.Program_Participant__c = participantProgramId;
            insert kit;
            saveResult.statusCode = 'OK';
            saveResult.dataRecord = new Kit_Locator__c();
        }catch(Exception ex)
        {
            Database.rollback(sp);
            saveResult.errorMessage = ex.getMessage() + ex.getStackTraceString();
            saveResult.statusCode = 'ERROR';
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
        
        return saveResult;
        
    }
    
    @AuraEnabled
    public static LTsObjectResult discardKit(Kit_Locator__c participantKit) {
        Savepoint sp = Database.setSavepoint();
        LTsObjectResult saveResult = new LTsObjectResult();
        try
        {
          	participantKit.Discarded__c = true;
            update participantKit;
            saveResult.statusCode = 'OK';
            saveResult.dataRecord = new Kit_Locator__c();
        }catch(Exception ex)
        {
            Database.rollback(sp);
            saveResult.errorMessage = ex.getMessage() + ex.getStackTraceString();
            saveResult.statusCode = 'ERROR';
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
        
        return saveResult;
        
    }

    @AuraEnabled
    public static List<Kit_Locator__c> getDataFromKit(){
        List<Kit_Locator__c> kitList = [SELECT Id, Status__c FROM Kit_Locator__c limit 10];
        try {
            return kitList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static LTsObjectResult removeParticipantKit(Kit_Locator__c participantKit) {
        Savepoint sp = Database.setSavepoint();
        LTsObjectResult saveResult = new LTsObjectResult();
        try
        {
            participantKit.Date_Ordered__c = null;
            participantKit.Status__c = null;
            participantKit.Program_Participant__c = null;
            participantKit.Reason_for_Testing__c = null;
            participantKit.Symptoms_Present__c = null;
            participantKit.Tempurature__c = null;
            participantKit.Patient_Consent__c = false;
            participantKit.Process_Immediately__c = false;
            participantKit.Collection_Date_Time__c = null;
            participantKit.Approving_Provider__c = null;
            participantKit.Photo_Id_Verified__c = false;
            update participantKit;
            saveResult.statusCode = 'OK';
            saveResult.dataRecord = new Kit_Locator__c();
        }catch(Exception ex)
        {
            Database.rollback(sp);
            saveResult.errorMessage = ex.getMessage() + ex.getStackTraceString();
            saveResult.statusCode = 'ERROR';
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
        
        return saveResult;
        
    }
    
    public class CustomizedField
    {
         @AuraEnabled
         public boolean isRequired;
        
         @AuraEnabled
         public boolean isVisible;
        
         @AuraEnabled
         public boolean isDisabled;
        
         @AuraEnabled
         public String altLabel;
    }
    
}