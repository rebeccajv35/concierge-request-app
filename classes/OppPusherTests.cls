@isTest
private class OppPusherTests {
 private static sObject[] OpptyList; 
 private static List<Opportunity> testOpptys = new List<Opportunity>();

    static testMethod void myOppUnitTest() {
        // create an oppty
        Opportunity oTestOppty=createOppty('testOppty');
        // set the date to Jan 1 of next year
        Integer myYear = Date.today().year();
        oTestOppty.CloseDate=date.newinstance(myYear+1,1,1);
        update oTestOppty;
        
        //check the push counter        
        Opportunity oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug('Push counter is: ' + oReadOppty.PushCount__c);
        System.assert(oReadOppty.PushCount__c==1);
        
        // update the close date to the 15th of January
        oTestOppty.CloseDate=date.newinstance(myYear+1,1,15);
        update oTestOppty;
        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug('After the first update, the push counter is: ' + oReadOppty.PushCount__c);
        System.assert(oReadOppty.PushCount__c==1);
        
        // move it out to the following year
        oTestOppty.CloseDate=date.newInstance(myYear+2, 1,1);
        update oTestOppty;
        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug('After the 2nd update, the push counter is: ' + oReadOppty.PushCount__c);
        System.assertEquals(oReadOppty.PushCount__c, 2);
        
        // don't change the date, no change
        oTestOppty.CloseDate=date.newInstance(myYear+2,1,1);
        update oTestOppty;
        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug('After the 3rd update, the push counter is: ' + oReadOppty.PushCount__c + ' (Should be the same)');
        System.assertEquals(oReadOppty.PushCount__c,2);
        
    }
    
    private static Opportunity createOppty(String sOppName) {
        Opportunity oNewOpp= new Opportunity(name= sOppName,closedate= date.newinstance(2015,11,11),stagename='Proposal',Sales_Step__c='Detailed Discovery - 20%');

    insert oNewOpp;
        testOpptys.add(oNewOpp);
        return oNewOpp;
    }
   
}