// use this to schedule this hourly from developer console
// System.schedule('Hourly UpdateRevSchedules', '0 0 * * * ?', new UpdateRevSchedules() );  
global class UpdateRevSchedules  implements Schedulable{
    //query all opportunity products that have been edited within the last 24 hours and 
    //have participation rate or unit price equal to zero 
    //and run them through the UpdateRevSchedules flow
    
    global void execute(SchedulableContext SC){
        
        updateMonthlyRevenue();
    }
    
    private void updateMonthlyRevenue()
    {
        
        Datetime d = datetime.now().addminutes(-90);
        System.debug('start time ' + d);
        List<OpportunityLineItem> oppProds = [SELECT Id from OpportunityLineItem 
                                              WHERE (UnitPrice = 0 OR Participation_Rate__c = 0 ) 
                                              AND SystemModStamp > :d];
        									//AND SystemModStamp >= LAST_N_DAYS:2];
		system.debug('processing ' + oppProds.size() + ' opportunity products');
        for(OpportunityLineItem op: OppProds)
        {
            Map<String, object> params = New Map<String, object>();
            params.put('OppProd', op.id);
            params.put('FromApex', true);
            Flow.Interview.UpdateRevSchedules theFlow = new Flow.Interview.UpdateRevSchedules(params);
       		theFlow.start();
        }  
    }
}