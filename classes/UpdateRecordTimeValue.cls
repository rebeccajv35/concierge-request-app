public with sharing class UpdateRecordTimeValue {
     
    public class Request {
        @InvocableVariable(label='Date/Time Value')
        public DateTime dateTimeValue; 
        
        @InvocableVariable(label='Record Id to Update')
        public ID recordId;
        
        @InvocableVariable(label='Name of the object with field to be updated')
        public String objectName;
        
        @InvocableVariable(label='Time Field to Populate/Update')
        public String fieldName;
        
        @InvocableVariable(label='Field Value')
        public String fieldValue;
    }
    
    public class Result {
        @InvocableVariable
        public Time newTimeValue;
    }
    
    @InvocableMethod(label='Update Time Field')
    public static List<Result> updateFields (List<Request> requests) {
       
        Result response = new Result();
        List<Result> responseWrapper = new List<Result>();
        
        for(Request request : requests){
            updateField(request);
            responseWrapper.add(response);
        }
        
        return responseWrapper;
    }
    
    private static String getQueryString(String objectName, String fieldName, String recordId){
        List<String> args = new String[]{fieldName, objectName, recordId};
            return String.format('SELECT Id, {0} FROM {1} WHERE Id = \'\'{2}\'\'', args);
    }
    
    public static Result updateField(Request request){
        
        Result response = new Result();

        string objectNameString = request.ObjectName;
        string fieldNameString = request.fieldName;
        string recordIdString = request.recordId;
       
        DateTime dateTimeValue = request.dateTimeValue;
        Integer hour = dateTimeValue.hour();
        Integer min = dateTimeValue.minute();
        Integer sec = dateTimeValue.second();
        Time newTimeValue = Time.newInstance(hour, min, sec, 0);
        System.debug('newTimeValue = '+ newTimeValue);
        
        String queryString = getQueryString(request.objectName, request.fieldName, request.recordId);
        
        List<sObject> sobjList = Database.query(queryString);
            //Database.query('SELECT Id, :fieldNameString FROM :objectNameString WHERE Id = :recordIdString');
        
        if(sobjList.size() > 0){
            SObject record = sobjList[0];
            record.put(request.fieldName, newTimeValue);
            update record;
        }
        
        response.newtimeValue = newTimeValue;
        
       return response;
       }

    
    }