public class OpportunityTriggerHandler {
    final List<Opportunity> newRecords;
    final Map<Id, Opportunity> oldMap;
    Map<Id, Opportunity> newMap;
    
    public OpportunityTriggerHandler( List<Opportunity> newRecords, Map<Id,Opportunity> oldMap )
    {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }
    
    public void afterUpdate()
    {
        // if opportunity probability = 0% - its closed Won, delete all the monthly revenue objects
        handleClosedOpportunities();
    }
    public void beforeDelete()
    {
        deleteMonthlyRevenues(oldmap.keySet());
    }
    
    public void handleClosedOpportunities()
    {
        Set<Id> closedOppty = new Set<Id>();
        
        for(Opportunity o: newRecords)
        {
            system.debug( 'probability =  ' + o.Probability);
            if(o.Probability == 0)
            {
                closedOppty.add(o.Id);
            }
        }
        
        if(closedOppty.size() > 0)
        {
            system.debug('closed lost oppty ' + closedOppty);
            deleteMonthlyRevenues(closedOppty);
        }
    }
    private void deleteMonthlyRevenues( Set<Id> closedOppty)
    {
        system.debug('in opportunity trigger deleteAssociatedMonthlyRevenues ');
        List<Monthly_Revenue__c> mrToBeDeleted = [SELECT Id FROM Monthly_Revenue__c WHERE Opportunity__c in :closedOppty];
        
        system.debug('mr to be deleted' + mrToBeDeleted);
        if(mrToBeDeleted.size() > 0)
        {
            delete mrToBeDeleted;
        }   
    }
}