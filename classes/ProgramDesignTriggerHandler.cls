public class ProgramDesignTriggerHandler 
{
    
    final List<Program_Design__C> newRecords;
    final Map<Id, Program_Design__c> oldMap;
    Map<Id, Program_Design__c> newMap;
    Map<Id, Decimal> probabilityMap = new Map<Id, Decimal>(); // map of Program Design ID to it's related opportunity's probability
    
    public ProgramDesignTriggerHandler( List<Program_Design__C> newRecords, Map<Id,Program_Design__c> oldMap )
    {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }
    public void beforeInsert()
    {
    }
    
    public void beforeUpdate(Map<Id, Program_Design__c> newMap)
    {
        this.newMap = newMap;
        getProbabilities();
        setReviewCycle();
        lockIfReviewStarted();
    }
    public void afterInsert()
    {
    }
    public void afterUpdate()
    {
        insertTasksAndReviews();
    }
    
    // save probabilities of the related opportunities
    private void getProbabilities()
    {
        List <Program_Design__c> pds = [SELECT id, name, opportunity_name__r.probability, Unlock_Record__c 
                                        FROM program_design__c 
                                        WHERE Id in :newMap.keySet()];
        for (Program_Design__c p: pds)
        {
            probabilityMap.put(p.Id, p.opportunity_name__r.probability );
        }
        
        //debug
        for(ID i : probabilityMap.keySet())
        {
            System.Debug('probablity = ' + probabilityMap.get(i));
        }
        
    }
    
    private List<Id> getReviewers(Decimal reviewCycle, String clientType, String stage)
    {
        // stage: new Sales or renewals
        // if new sales, then status changes from Needed from Sales to Completed by Sales
        // if renewal, then the status changes from Needed from Client Management to Completed By Client Management
        List<PD_Reviewer__mdt> reviewers;
        
        if(reviewCycle == 1)
        {
            if(clientType == 'Health Plan')
            {
                if(stage == 'New Sales')
                {
                    reviewers = [SELECT User_ID__c, Review_Cycle_1__c, client_type_health_plan__c, New_Sales__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_1__c = true AND client_type_health_plan__c = true AND New_Sales__C= true];  
                }
                else // stage should be renewals
                {                        
                    reviewers = [SELECT User_ID__c, Review_Cycle_1__c,  client_type_health_plan__c, Renewals__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_1__c = true AND client_type_health_plan__c = true AND Renewals__C= true];  
                }
            }
            else // client type other
            {
                if(stage == 'New Sales')
                {
                    reviewers = [SELECT User_ID__c, Review_Cycle_1__c, client_type_other__c, New_Sales__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_1__c = true AND client_type_other__c = true AND New_Sales__C= true];  
                }
                else // stage should be renewals
                {                        
                    reviewers = [SELECT User_ID__c, Review_Cycle_1__c,  client_type_other__c, Renewals__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_1__c = true AND client_type_other__c = true AND Renewals__C= true];  
                }                
            }
            
        }// end if review cycle 1
        else // review cycle 2 or greater
        {
            if(clientType == 'Health Plan')
            {
                if(stage == 'New Sales')
                {
                    reviewers = [SELECT User_ID__c, Review_Cycle_2__c, client_type_health_plan__c, New_Sales__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_2__c = true AND client_type_health_plan__c = true AND New_Sales__C= true];  
                }
                else // stage should be renewals
                {                        
                    reviewers = [SELECT User_ID__c, Review_Cycle_2__c,  client_type_health_plan__c, Renewals__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_2__c = true AND client_type_health_plan__c = true AND Renewals__C= true];  
                }
            }
            else // client type other
            {
                if(stage == 'New Sales')
                {
                    reviewers = [SELECT User_ID__c, Review_Cycle_2__c, client_type_other__c, New_Sales__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_2__c = true AND client_type_other__c = true AND New_Sales__C= true];  
                }
                else // stage should be renewals
                {                        
                    reviewers = [SELECT User_ID__c, Review_Cycle_2__c,  client_type_other__c, Renewals__C
                                 FROM PD_Reviewer__mdt
                                 WHERE Review_Cycle_2__c = true AND client_type_other__c = true AND Renewals__C= true];  
                }                
            }
        }
        
        List<Id> users = new List<Id>();
        
        for ( PD_Reviewer__mdt r: reviewers)
        {
            users.add(r.User_ID__c);
        }
        
        return users;
        
    }
    private List<Id> getReviewersOld(Decimal reviewCycle, String clientType)
    {
        List<PD_Reviewer__mdt> reviewers = [SELECT User_ID__c, Review_Cycle_1__c, Review_Cycle_2__c, client_type_other__c, client_type_health_plan__c
                                            FROM PD_Reviewer__mdt];   
        List<Id> users = new List<Id>();
        
        for ( PD_Reviewer__mdt r: reviewers)
        {
            if(clientType == 'Health Plan')
            {
                if(reviewCycle == 1)
                {
                    if (r.Review_Cycle_1__c == true  && r.client_type_health_plan__c == true)
                    {
                        users.add(r.User_ID__c);
                    }
                }
                else // for all other review cycles we will use review cycle 2 = checked 
                {
                    if (r.Review_Cycle_2__c == true  && r.client_type_health_plan__c == true)
                    {
                        users.add(r.User_ID__c);
                    }
                } 
            }
            else // for all other health plan types
            {
                if(reviewCycle == 1)
                {
                    if (r.Review_Cycle_1__c == true  && r.client_type_other__c == true)
                    {
                        users.add(r.User_ID__c);
                    }
                }
                else // for all other review cycles we will use review cycle 2 = checked 
                {
                    if (r.Review_Cycle_2__c == true  && r.client_type_other__c == true)
                    {
                        users.add(r.User_ID__c);
                    }
                } 
            }
            
        }
        
        return users;
    }
    
    // get list of reviewers for the review cycle and client type and create review for each user
    private List<Review_Item__c> insertReviews(Program_Design__c pd)
    {
        
        List <Review_Item__c> reviewsList = new List<Review_Item__c> ();
        
        List<Id> users = getReviewers(pd.Review_Cycle__c, pd.client_type__c, pd.Stage__c);
        for(ID u: users)
        {
            reviewsList.add(createPendingReview(pd, u));
        }
        return reviewsList;
        
    }
    
    
    // get list of reviewers for the review cycle and client type and create task for each user
    private List<task> insertTasks(Program_Design__c pd)
    {
        List <Task> tasksList = new List<Task> ();
        
        List<Id> users = getReviewers(pd.Review_Cycle__c, pd.client_type__c, pd.Stage__c);
        for(ID u: users)
        {
            tasksList.add(createTask(pd, u));
        }
        
        return tasksList;
    }
    
    private Review_Item__c createPendingReview(Program_Design__c pd, Id userID)
    {            
        Review_Item__c ri = new Review_Item__c();
        if(pd.Review_Cycle__c == 1)
        {
            ri.review_cycle__c = 'Initial Review';            
        }
        else if (pd.review_cycle__C == 2)
        {
            ri.review_cycle__c = 'Secondary Review';
        }
        else if (pd.review_cycle__c == 3)
        {
            ri.review_cycle__c = 'Third Review';
        }
        else
        {
            ri.review_cycle__c = 'Extra Review';
        }
        
        
        
        ri.review_status__c= 'Pending';
        ri.program_design__c = pd.Id;
        ri.Reviewer__c = userID;
        return ri;
    }
    
    private Task createTask(Program_Design__c pd, Id userID)
    {
        Task t  = new Task();
        t.ownerId = userId;
        t.subject ='Program Design Pending Review';
        t.Description = 'Please review this Program Design';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = pd.Id;
        t.ActivityDate = date.today() + 1;
        t.Type = 'To-Do';
        return t; 
    }
    /**
private void initializeReviewCycle()
{

for(Program_Design__c pd:newRecords)
{
System.Debug('before review cycle number' + pd.Review_Cycle__c);
if( pd.Program_Design_Checklist_status__c.equals('Completed by Sales')
&& checkListStatusChanged(pd))
{
pd.Review_Cycle__c = 0;
}
}
}
**/
    private void setReviewCycle()
    {
        
        for(Program_Design__c pd:newRecords)
        {
            System.Debug('before review cycle number' + pd.Review_Cycle__c);
            if(( pd.Program_Design_Checklist_status__c.equals('Completed by Sales') || pd.Program_Design_Checklist_status__c.equals('Completed by Client Management'))
               && checkListStatusChanged(pd))
            {

                // if opportunity at 80% - start review cycle at 2
                Decimal prob = probabilityMap.get(pd.Id);
                if(prob == 80 && pd.Review_Cycle__c < 2)
                {
                    pd.Review_Cycle__c = 2;
                }
                else
                {
                    pd.Review_Cycle__c++;
                    
                }
                pd.Review_Status__c = 'Active';
                System.debug('after review cycle number ' + pd.Review_Cycle__c);
                
            }
        }
    }
    
    private boolean checkListStatusChanged(Program_Design__c pd)
    {
        //System.debug('old status = ' + oldMap.get(pd.id).Program_Design_Checklist_status__c);
        //System.debug('new status = ' +  pd.Program_Design_Checklist_status__c);       
        return oldMap.get(pd.id).Program_Design_Checklist_status__c != pd.Program_Design_Checklist_status__c;
    }
    
    //set stage
    //lock if review started
    // unlock if review completed
    private  void lockIfReviewStarted()
    {
        for(Program_Design__c pd:newRecords)
        {
            System.Debug('lockifreviewstarted.....  pd status ' + pd.Program_Design_Checklist_status__c );
            if(pd.Unlock_Record__c==TRUE){approval.unlock(pd.id);}
            if(pd.Program_Design_Checklist_status__c.equals('Completed by Sales'))
            {
                // only lock if this status was changed
                if(checkListStatusChanged(pd))
                {
                    pd.stage__c = 'New Sales';
                    //pd.Record_Locked__c = true;
                    //Approval.Lock(pd.id);
                    pd.Program_Design_Checklist_status__c = 'Under Cross-Functional Review';
                }
            }
            else if (pd.Program_Design_Checklist_status__c.equals('Completed by Client Management'))
            {
                // only lock if this status was changed
                if(checkListStatusChanged(pd))
                {
                    pd.stage__c = 'Renewals';
                    //pd.Record_Locked__c = true;
                    //Approval.Lock(pd.id);
                    pd.Program_Design_Checklist_status__c = 'Under Cross-Functional Review';
                }                
            }
            else if(pd.Program_Design_Checklist_status__c.equals('Under Cross-Functional Review') && pd.Current_Review_Status__c == 0)
            {
                System.Debug('unlock records');
                unlockIfReviewCompleted();
            }
        }
    }
    
    private  void insertTasksAndReviews()
    {
        List <Review_Item__c> reviewsToBeInserted = new List<Review_Item__c>();
        List <Task> tasksToBeInserted = new List<Task>();
        
        for(Program_Design__c pd:newRecords)
        {
            if(pd.Program_Design_Checklist_status__c.equals('Under Cross-Functional Review'))
            {
                // only lock if this status was changed
                if(checkListStatusChanged(pd))
                {
                    reviewsToBeInserted.addAll(insertReviews(pd));
                    tasksToBeInserted.addAll(insertTasks(pd));
                }
            }
        }
        insert(tasksToBeInserted);
        insert(reviewsToBeInserted);
    }
    
    private void unlockIfReviewCompleted()
    {
        for(Program_Design__c pd:newRecords)
        {
            if(pd.current_review_Status__c == 0 )
            {
                system.debug('found review to be completed - unlock record');
                pd.Record_Locked__c = false;
                pd.Review_Status__c = 'Completed';
                Approval.Unlock(pd.Id);
                
                if(pd.Review_Cycle__c == 1)
                {
                    pd.Program_Design_Checklist_status__c = 'Passed TGC-X (40%)';
                }
                
                if(pd.Review_Cycle__c == 2)
                {
                    pd.Program_Design_Checklist_status__c = 'Passed TGC-X (80%)';
                }
                
                // TBD - should status be different for each cycle?
                // for any review cycles greater than or equal to 3, use this status
                if(pd.Review_cycle__c >= 3) 
                {
                    pd.Program_Design_Checklist_status__c = 'Passed TGC-X (80%)'; 
                }
            }
        }
    }
    
}