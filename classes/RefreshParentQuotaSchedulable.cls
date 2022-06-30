global class RefreshParentQuotaSchedulable implements Schedulable {
    global void execute(SchedulableContext SC){
        assignQuotas();
    }
    
    private void assignQuotas(){
        
        List<quota__c> revs = [SELECT Id, TriggerField__c FROM Quota__c WHERE (Need_to_Refresh__c = true and Do_not_report_Child_Annual_Revenue__c > 0)];
        
        if(revs.size() == 0)
        {
            System.debug('nothing to update');
            return; 
        }
        
        for(quota__c mr: revs)
        {
            Map<String, Object> params = new Map<String, Object>();
            params.put('QuotaID', mr.Id);
            Flow.Interview.Update_Quota_Numbers recordUpdaterFlow = new Flow.Interview.Update_Quota_Numbers(params);
            recordUpdaterFlow.start();
        }
    }
}