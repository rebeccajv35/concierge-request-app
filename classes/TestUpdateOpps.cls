@isTest public class TestUpdateOpps {
    
   static testmethod void TestUpdateOpps(){
        
    Account acct = new Account(Name = 'testAcct');
        insert acct;
        Date oldDate = System.today().addDays(-400);
        
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp1',  
                                               AccountId = acct.Id, 
                                               Type = 'New Business', 
                                               StageName = 'Evaluation', 
                                               probability = 100,
                                               Vertical__c = 'Healthplan', 
                                               CloseDate = oldDate, 
                                              Sales_Step__c = 'Business Planning - 1%');
        insert testOpp1;

   // OppBatchScheduler.executefuture();
        
    }
    
}