@isTest(SeeAllData=true)
public class ParticipantKitQuickControllerTest {
    
    /*
@testSetup
static void setup() { 


Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
User u = new User(Alias = 'utuser', Email = 'unittestuser@testorg1.com',
EmailEncodingKey = 'UTF-8', LastName = 'unittestuser', FirstName = 'unit2testuser', LanguageLocaleKey = 'en_US',
LocaleSidKey = 'en_US', ProfileId = p.Id, 
TimeZoneSidKey = 'America/Los_Angeles', UserName = 'unittestuser@testorg1.com');

insert u;




Account account = new Account();
account.Name = 'Test';
account.ownerId = u.Id;
insert account;




Contact participant = new Contact(
FirstName='TEST',
LastName='TEST',
AccountId = account.Id,
RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Participant').getRecordTypeId()
);
insert participant;



}
*/
    
    static testMethod void getProgramProjectFieldCustomizations()
    {
        Program_Project__c programProject = [Select Id, Account__c from Program_Project__c where Program_Status__c = 'Active' LIMIT 1 ];
        Program_Project_Field_Customization__c ppc = new Program_Project_Field_Customization__c();
        ppc.Program_Project__c = programProject.Id;
        ppc.Field__c = 'Race';
        ppc.Section__c = 'Participant';
        ppc.Alternate_Label__c = null;
        ppc.Required__c = true;
        ppc.Visible__c = false;
        insert ppc;
        Map<String, ParticipantKitQuickController.CustomizedField> fieldMap = ParticipantKitQuickController.getProgramProjectFieldCustomizations(programProject.Id);
        System.assertEquals(true, fieldMap.size() > 0);
        
        
    }
    
    static testMethod void getCurrentUserInfo()
    {
        User user = ParticipantKitQuickController.getCurrentUserInfo();
        System.assertEquals(true, user != null);
    }
    
    static testMethod void getApprovingProviders()
    {
        Program_Project__c programProject = [Select Id, Account__c from Program_Project__c where Program_Status__c = 'Active' LIMIT 1 ];
        Physician__c physician = new Physician__c();
        physician.Program_Project__c = programProject.Id;
        physician.First_Name__c = 'Test';
        physician.Last_Name__c = 'Physician';
        physician.NPI__c = '213456789';
        insert physician;
        
        User u = [Select Id from user where Id=: UserInfo.getUserId()];
        u.NPI_Number__c = '111111111';
        update u;
        
         Map<String, String> physicianMap = ParticipantKitQuickController.getApprovingProviders(programProject.Id);
         System.assertEquals(true, physicianMap.size() > 0);
        
        
        
    }
    
    static testMethod void getPicklistValues() {
        Map<String, String> pickListValues = ParticipantKitQuickController.getPicklistValues('Contact', 'Contact_Role__c');
        System.assertEquals(true, pickListValues.size() > 0);
        
    }
    
    static testMethod void getAccountActivePrograms() {
        
        Program_Project__c programProject = [Select Id, Account__c from Program_Project__c where Program_Status__c = 'Active' LIMIT 1 ];
        
        Contact participant = new Contact(
            FirstName='TEST',
            LastName='TEST',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Participant').getRecordTypeId()
        );
        insert participant;
        
        Account_Company__c company = new Account_Company__c();
        company.Name = '123456';
        company.Account__c = programProject.Account__c;
        insert company;
        
        Company_Facility__c facility = new Company_Facility__c();
        facility.Name = 'TEST';
        facility.Account_Company__c = company.Id;
        insert facility;
        
        Program_Participant__c programParticipant = new Program_Participant__c();
        programParticipant.Participant__r = participant;
        programParticipant.Participant__c = participant.id;
        programParticipant.Program__c = programProject.id; 
        programParticipant.Status__c = 'Enrolled';
        insert programParticipant;
        
        
        Kit_Locator__c kit = new Kit_Locator__c();
        kit.Name = 'TEST';
        kit.Patient_Consent__c = true;
        kit.Program_Participant__c = programParticipant.Id;
        insert kit;
        ParticipantKitQuickController.getProgramParticipants(programProject.Account__c, programProject.Id, company.Id, 
                                                             facility.Id, 'test', 'test', 'test', date.today(),'test@test.com');

        ParticipantKitQuickController.suggestProgramParticipants(programProject.Account__c, programProject.Id, company.Id, 
                                                             facility.Id, 'test', 'test', 'test', date.today(),'test@test.com');
        ParticipantKitQuickController.suggestContacts(programProject.Account__c, 'test', 'test', 'test', date.today(), 'test@test.com');
        

            
        String programParticipantJSON = System.JSON.serialize(programParticipant);
        
        ParticipantKitQuickController.initializeNewParticipant(programProject.Account__c,programProject.Id, company.Id, facility.Id);
        ParticipantKitQuickController.getAccountProgramCompanies(programProject.Id);
        ParticipantKitQuickController.getProgramCompanyFacility(programProject.Id, company.Id);
        ParticipantKitQuickController.saveProgramParticipant(programParticipantJSON, 
                                                             programProject.Account__c,
                                                             programProject.Id, 
                                                             company.Id, 
                                                             facility.Id, 
                                                             kit.Id); 
        
    }
    
    static testMethod void getActivePrograms()
    {
        
        
        Contact participant = new Contact(
            FirstName='TEST',
            LastName='TEST',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Participant').getRecordTypeId()
        );
        insert participant;
        
        Program_Project__c programProject = [Select Id, Account__c from Program_Project__c where Program_Status__c = 'Active' LIMIT 1 ];
        Program_Participant__c programParticipant = new Program_Participant__c();
        programParticipant.Participant__c = participant.id;
        programParticipant.Program__c = programProject.id; 
        programParticipant.Status__c = 'Enrolled';
        insert programParticipant;
        
        Kit_Locator__c kit = new Kit_Locator__c();
        kit.Name = 'TEST';
        kit.Patient_Consent__c = true;
        kit.Program_Participant__c = programParticipant.Id;
        insert kit;
        
       	ParticipantKitQuickController.initializeNewKit(programProject.Id);
        ParticipantKitQuickController.checkValidParticipantKit('TEST',programProject.Id);
        ParticipantKitQuickController.searchKit('TEST', programProject.Account__c);
        ParticipantKitQuickController.getActivePrograms(programProject.Account__c);
        ParticipantKitQuickController.getParticipantProgramKits(programParticipant.Id);
        ParticipantKitQuickController.saveParticipantKit(kit.Id, programParticipant.Id);
        ParticipantKitQuickController.removeParticipantKit(kit);
    }
    
    static testMethod void getCompanyFacility()
    {
        Contact participant = new Contact(
            FirstName='TEST',
            LastName='TEST',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Participant').getRecordTypeId()
        );
        insert participant;
        
       Account_Company__c company = new Account_Company__c();
        
       Program_Project__c programProject = [Select Id, Account__c from Program_Project__c where Program_Status__c = 'Active' LIMIT 1 ];
       
        company.Program_Project__c = programProject.Id;
        insert company;
        
        Company_Facility__c facility = new Company_Facility__c(
           Account_Company__c = company.Id
        );
        insert facility;
        
        Program_Participant__c programParticipant = new Program_Participant__c();
        programParticipant.Participant__c = participant.id;
        programParticipant.Program__c = programProject.id; 
        programParticipant.Status__c = 'Enrolled';
        programParticipant.Account_Company__c = company.id;
        programParticipant.Company_Facility__c = facility.id;
        insert programParticipant;
        
        Map<String, String> facilityMap = ParticipantKitQuickController.getProgramCompanyFacility(programProject.Id, company.Id);
        System.assertEquals(true, facilityMap.size() > 0);
        
    }
    
   
    
    
    
    
    
    
}