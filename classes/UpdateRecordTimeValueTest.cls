@isTest
public with sharing class UpdateRecordTimeValueTest {
 
    @isTest
    public static void updateTimeField_Success(){
        
        Testing_Request__c tr = new Testing_Request__c();
        tr.name = 'test record';
        insert tr;
        
        UpdateRecordTimeValue.Request testRequest = new UpdateRecordTimeValue.Request();
        
        testRequest.dateTimeValue = Datetime.newInstance(2022, 6, 23, 12, 0, 0);
        testRequest.recordId = tr.Id;
        testRequest.objectName = 'Testing_Request__c';
        testRequest.fieldName = 'Test_Time__c';
        Time compareTime = Time.newInstance(12,0,0,0);
        
        List<UpdateRecordTimeValue.Request> testRequestList = new List<UpdateRecordTimeValue.Request>();
        testRequestList.add(testRequest);
        
        List<UpdateRecordTimeValue.Result> testResponseList = UpdateRecordTimeValue.updateFields(testRequestList); 
       
        Testing_Request__c updatetr = [SELECT Id, Test_Time__c FROM Testing_Request__c WHERE Id = :tr.Id];
        
        system.debug('new Test_Time__c value = ' + testResponseList[0].newTimeValue);
        system.debug('compareTime value = ' + compareTime);
        system.debug('updateTR Test_Time__c value = ' + updatetr.Test_Time__c);
        system.assertEquals(compareTime, updatetr.Test_Time__c);
        
 
        
    }
}