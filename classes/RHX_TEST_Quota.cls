@isTest(SeeAllData=true)
public class RHX_TEST_Quota {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Quota__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Quota__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}