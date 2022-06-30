@isTest(SeeAllData=true)
public class RHX_TEST_Program_Project {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Program_Project__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Program_Project__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}