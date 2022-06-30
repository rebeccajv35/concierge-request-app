@isTest
public class LCFormsTest {
    
    static testMethod void testCovanceFormTrigger()
    {
        User u = getTestUser();
        Account a = getTestAccount();
        Opportunity o = getTestOpportunity(a);
        Program_Project__c pp = getTestProgramProject(o);
        
       
        
        Covance_Program_Form__c covanceForm = new Covance_Program_Form__c(
            BioIQ_Requester__c = u.id, 
            Program_Project__c = pp.Id,
            Estimated_Program_Volume__c = '1000',
            Kit_Types__c = 'iFobt', 
            In_Kit_Letter_Required__C = 'Yes', 
            Print_Type__c = 'Color',
            Multiple_Brands__c = 'Yes',
            Brand_Names__c = 'one, two, three',
            Deployment_Type__c = 'Autodeploy'
        );
        
        insert covanceForm;
       
        
    }
    
    static testMethod void testPWNFormTrigger()
    {
        User u = getTestUser();
        Account a = getTestAccount();
        Opportunity o = getTestOpportunity(a);
        Program_Project__c pp = getTestProgramProject(o);
        
        PWN_Acct_Form__c pwnForm = new PWN_Acct_Form__c(
            BioIQ_Requester__c = u.id, 
            Program_Project__c = pp.Id,
            Estimated_Program_Volume__c = '1000',
            specialized_outreach_required__c = 'Yes', 
            certified_mail__c = 'No', 
            Requested_Due_Date__c = System.today() + 10,
            Custom_Call_Scripts__c = 'Yes',
            Custom_UTR_Letter__c = 'Yes'
        );
        
        insert pwnForm;
        
        
    }
    static testMethod void testLCAccountRequestFormTrigger()
    {
        User u = getTestUser();
        Account a = getTestAccount();
        Opportunity o = getTestOpportunity(a);
        Program_Project__c pp = getTestProgramProject(o);
        
        
        LC_Account_Request_Form__c lcAcct = new LC_Account_Request_Form__c(
            Program_Project__c = pp.Id,
            BioIQ_REquester__c = u.Id, 
            BioIQ_Client__c = a.Id, 
            Requested_Due_Date__c = System.today() + 10,
            Deployment_Type__c = 'Opt-In',
            HealthPlan_Product_Type__c = 'Medicare',
            Ordering_Physician_Network__c = 'CNH',
            Estimated_Program_Volume__c = '1000',
            Specialized_Outreach__c = 'Yes',
            Billing_Method__c = 'Claims Based Billing',
            Shipment_Type__c = 'Direct to Member',
            Kit_Types__c = 'iFobt'
        );
        
        insert lcAcct;
        
    }

    static testMethod void testLCPricingFormTrigger()
    {

        User u = getTestUser();
        Account a = getTestAccount();

        LC_Pricing_Request_Form__c lcPriceForm =  new LC_Pricing_Request_Form__c(
            BioIQ_Requester__c = u.id, 
            Estimated_Program_Volume__c = '1000',
            Kit_Types__c = 'iFobt', 
            Product_Services__c = 'Kit Pricing', 
            Prospect__c = a.Id,
            Additional_Information__c = 'more info',
            Requested_Due_Date__c = System.today() + 10);
  
        insert lcPriceForm;
    }
    
    static User getTestUser()
    {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operations New'].Id,
            LastName = 'last',
            Email = 'testuserlcform@bioiq.com',
            Username = 'testuserlcform@bioiq.com',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'//,
        );
        insert u;
        return u;
    }
    
    static Account getTestAccount()
    {
        Account a = new Account(Name = 'Test Account');
        a.BillingStreet = '123 Any Street';
        a.BillingCity = 'testcity';
        a.BillingState = 'Maryland';
        a.BillingPostalCode = '12345';
        insert a;
        return a;
    }
    
    static Opportunity getTestOpportunity(Account a)
    {
        
        Opportunity o = new Opportunity (
            Name = 'opportunity 1', 
            Account = a, 
            Type = 'New Business',
            Vertical__c = 'HealthPlan',
            StageName = 'Proposal',
            Sales_Step__c = 'Detailed Discovery - 20%',
            CloseDate = System.today() + 10,
            LeadSource = 'Conference',
            Deal_Lives__C = 1   
        );
        insert o;
        return o;
    }
    
    static Program_Project__c getTestProgramProject(Opportunity o)
    {
                
        Program_Project__c pp = new Program_Project__c();
        pp.name = 'AA123';
        pp.Opportunity__c = o.Id;
        pp.Program_Client_Type__c = 'HealthPlan';
        pp.Implementation_Stoplight_Status__c = 'Green';
        pp.At_Risk_Status__c = 'Not At Risk';
        pp.Client_Management_Stoplight_Status__c = 'Green';
        pp.Vendor_Mgmt_Stoplight_Status__c = 'Green';
        
        insert pp;
        return pp;
    }

    
}