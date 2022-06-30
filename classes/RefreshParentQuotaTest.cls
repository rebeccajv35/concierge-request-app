@istest
public class RefreshParentQuotaTest {
    
 public static String CRON_EXP = '0 0 * * * ?';
    
    static testmethod void testUpdateRevSchedules(){
        Account testAcc1 = new Account(Name = 'Test Acc1');
        insert testAcc1;
        
        //-----
        Product2 prod = new Product2(Name = 'Test product', productcode='test123');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp1', AccountId = testAcc1.Id, 
                                               Type = 'New Business', 
                                               Vertical__c = 'Healthplan', 
                                               StageName = 'Evaluation', 
                                               Sales_Step__c = 'Qualified Lead', 
                                               Product_Category__c = 'BioIQ Star', 
                                               CloseDate = Date.newInstance(2025,1,1), 
                                               LeadSource = 'Prospecting (Self)', 
                                               Deal_Lives__c = 1500);
        testOpp1.Pricebook2Id = customPB.Id; //pbook.Id;
        insert testOpp1;
        

        //Process builder is setting the PB to HealthPlan - need to reset it here
        testOpp1.Pricebook2Id = customPB.Id;
        update testOpp1;
        
        OpportunityLineItem oppProd = new OpportunityLineItem();
        oppProd.OpportunityId = testOpp1.id;
        oppProd.Product2Id = prod.Id;
        oppProd.quantity = 20;
        oppProd.TotalPrice = 2500.00;
        oppProd.Participation_Rate__c = 40;
        oppProd.PricebookEntryId = customPrice.Id;
        insert oppProd;       
        
      /*  quota__c q1 = new quota__c();
        q1.year__c = '2018';
        q1.Sale_Type__c = 'New Business';
        q1.ProbAdj_Do_Not_Report__c = 1;
        q1.Number_of_Monthly_Revs_Linked__c = 1;
        q1.Do_not_report_Child_Annual_Revenue__c = 0;
        insert q1;
        
        quota__c q2 = new quota__c();
        q2.year__c = '2018';
        q2.Sale_Type__c = 'New Business';
        q2.ProbAdj_Do_Not_Report__c = 1;
        q2.Do_not_report_Child_Annual_Revenue__c = 2;
        insert q2; */
        
        Test.startTest();
        // Schedule the test job
        
        String jobId = System.schedule('UpdateRevSchedulestest',
                                       CRON_EXP, 
                                       new RefreshParentQuotaSchedulable());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        // System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();

    }
    
}