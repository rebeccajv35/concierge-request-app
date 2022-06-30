@isTest(SeeAllData=true)
public class CaseRecordTypeSelectorControllerTest {
    
    static testMethod void getRecordTypeValues(){
        Map<Id, String> recordTypeMap = CaseRecordTypeSelectorController.fetchRecordTypeValues('Case');
        System.assertEquals(true, recordTypeMap.size() > 0);
    }

}