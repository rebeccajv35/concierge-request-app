@isTest(SeeAllData=true)
public class RHX_TEST_Sales_Invoice {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Sales_Invoice__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Sales_Invoice__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}