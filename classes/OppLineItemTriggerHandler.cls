public class OppLineItemTriggerHandler {
    final List<OpportunityLineItem> newRecords;
    final Map<Id, OpportunityLineItem> oldMap;
    Map<Id, OpportunityLineItem> newMap;
    
    public OppLineItemTriggerHandler( List<OpportunityLineItem> newRecords, Map<Id,OpportunityLineItem> oldMap )
    {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }
    
    public void afterDelete()
    {
        deleteAssociatedMonthlyRevenues();
    }
    
    private void deleteAssociatedMonthlyRevenues()
    {
        system.debug('in deleteAssociatedMonthlyRevenues ');
        // Monthly Revenue Opp_prod_id__c is a string not ID so can't filter on that.
        // filter by opportunity, then look at each to see if it is part of the delete opportunity line item
        // 
        Set<Id> opptyIdList = new Set<Id>();
        
        for(OpportunityLineItem oli: oldMap.values())
        {
            opptyIdList.add(oli.OpportunityId);
        }
        List<ID> oppLineItemIDs = new List<ID> ();

        List<Monthly_Revenue__c> mrList = [SELECT Id, Name, Opp_Prod_ID__c FROM Monthly_Revenue__c WHERE Opportunity__c in :opptyIdList];
        
        List<Monthly_Revenue__c> mrToBeDeleted = new List <Monthly_Revenue__c> ();
        
        for(Monthly_Revenue__c mr: mrList)
        {
            Id currentId = Id.valueof(mr.opp_prod_ID__C);
            if(oldmap.keySet().contains(currentID)){mrToBeDeleted.add(mr);}

        }
        
        system.debug('mr to be deleted' + mrToBeDeleted);
        if(mrToBeDeleted.size() > 0){delete mrToBeDeleted;}
    }
}