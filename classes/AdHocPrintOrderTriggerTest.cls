@isTest
public class AdHocPrintOrderTriggerTest {
    
    static testMethod void testAdHocTrigger()
    {

        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operations New'].Id,
            LastName = 'last',
            Email = 'testuseradhoc@bioiq.com',
            Username = 'testuseradhoc@bioiq.com',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'//,
        );
        insert u;
        system.runas (u){
        Account a = new Account(Name = 'Test Account',
                               BillingState = 'Florida');
        insert a;
        
        Opportunity o = new Opportunity (
            Name = 'opportunity 1', 
            Account = a, 
            Type = 'New Business',
            Vertical__c = 'Healthplan',
            StageName = 'Evaluation',
            Sales_Step__c = 'Info Gathering - 5%',
            CloseDate = System.today() + 10,
            LeadSource = 'Conference',
            Deal_Lives__C = 1   
        );
        insert o;
        
        Program_Project__c pp = new Program_Project__c();
        pp.name = 'AA123';
        pp.Opportunity__c = o.Id;
        pp.Program_Client_Type__c = 'Healthplan';
        pp.Implementation_Stoplight_Status__c = 'Green';
        pp.At_Risk_Status__c = 'Not At Risk';
        pp.Client_Management_Stoplight_Status__c = 'Green';
        pp.Vendor_Mgmt_Stoplight_Status__c = 'Green';
        
        insert pp;
        
        Test.startTest();
        
        Ad_Hoc_Print_Order__c order = new Ad_Hoc_Print_Order__c(
            Print_Type__c = 'Color',
            Copy_Output__c = 'Print Single-Sided', 
            Paper_Color__c = 'White', 
            Paper_Type__c = 'Other', 
            Paper_Type_Other__c = 'Other Paper Type',
            Paper_Size__c = '8.5" x 11"', 
            Folding__c = 'Half',
            Envelope_Type__c = 'Single Window with CMS Tagline',
            Mail_Type__c = 'Reminder Letters',
            Additional_Notes__c = 'Additional Notes',
            Live_Pulls__c = 'Number and Type of Pulls Requested',
            Mailing__c = 'CASS & NCOA Presorted',Invoice_Needed__c = true, 
            Number_of_Records__c = 10, 
            Number_of_Templates__c = 1,
            Template_File_Name__c = 'test.csv',
            Number_of_Data_Files__c = 1,
            Data_File_Name_s__c = 'Data.csv',
            Creative_Proof__c = 'Required',
            Requested_Mail_Date__c = System.today() + 10,
            Does_it_Require_an_Address_page__c = true
        );
        order.BioIQ_Requester__c = u.Id;
        order.Program_Project__c = pp.Id;
        
        insert order;
        
        test.stopTest();
        }
    }
    
}