@isTest
public class OpportunityCleanupSchedulableTest {
    
    static testmethod void opportunitySchedTest()
    {
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
        
        Opportunity testOpp2 = new Opportunity(Name = 'Test Opp2',  
                                               AccountId = acct.Id, 
                                               Type = 'New Business', 
                                               StageName = 'Evaluation', 
                                               probability = 0,
                                               Vertical__c = 'Healthplan', 
                                               CloseDate = system.today(), 
                                               Sales_Step__c = 'Business Planning - 1%');
        insert testOpp2;
        
        
        system.debug(testopp1);
        Test.startTest();
        String sch = '0 5 0 * * ?'; // run every day 5 minutes after midnight
        String jobId = System.Schedule('OpportunityCleanupSchedulable', sch, new OpportunityCleanupSchedulable());
        Test.stopTest();
        
        List<Opportunity> ops = [SELECT Id, active_account__c FROM Opportunity];
        system.debug(ops);
        for(Opportunity o: ops)
        {
            //System.assert(o.active_account__c == null);
			System.assertEquals(null, o.Active_Account__c);
        }
        
    }
}