public class ReviewItemTriggerHandler 
{
    final List<Review_Item__C> newRecords;
    final Map<Id, Review_Item__c> oldMap;
    List<Messaging.email> emailMessages = new List<Messaging.email>();
    Public String emailBody;
    List <PD_Review_Delegates__mdt> delegatesList;
    
    
    public ReviewItemTriggerHandler( List<Review_Item__C> newRecords,Map<Id,Review_Item__C> oldMap )
    {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }
    public void beforeInsert()
    {
        System.Debug('ReviewItemTriggerHandler.beforeInsert');
        // validateUser(); - this prevents denise adamson for creating reviews
    }
    
    public void beforeUpdate()
    {
        System.Debug('ReviewItemTriggerHandler.beforeupdate');
        validateUser();
    }
    
    public void afterInsert()
    {
        System.Debug('ReviewItemTriggerHandler.afterinsert');
        sendEmails();
    }
    
    public void afterUpdate()
    {
        System.Debug('ReviewItemTriggerHandler.afterupdate - not implemented yet');
    }
    
    
    private void sendEmails()
    {
        for(Review_Item__c rev : newRecords)
        {
            if(rev.Reviewer__c == '005340000090lH5') // TBD hardcoded to only Sharla at the moment
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(rev.Reviewer__c);
                message.setWhatID(rev.Id);
                message.setSubject('Pending review');
                emailBody = 'Please review this ';
                emailBody += URL.getSalesforceBaseUrl().toExternalForm() + '/' + rev.Id;
                message.setplaintextbody(emailBody);
                
                emailMessages.add(message);
                message.setSaveAsActivity(false);
            }
        }
    }
    private void validateUser()
    {        
        List<Profile> profiles = getProfileInfo();
        
        for(Review_Item__c rev : newRecords)
        {
            //if(UserInfo.getUserId() != rev.Reviewer__c  && UserInfo.getProfileId() != '00e800000015PEYAA2' && UserInfo.getProfileId() != '00e34000001KXZ0' )// allow sys admins and delegates to edit)
            if(UserInfo.getUserId() != rev.Reviewer__c && !currentUserIsADelegate(profiles))
            {
                rev.addError('You cannot edit reviews assigned to other users');
            }
        }
    }
    
    private List<Profile> getProfileInfo()
    {
        if(delegatesList == null)
        {
            
            delegatesList = [SELECT Profile_Name__c FROM PD_Review_Delegates__mdt ];
        }
        
        List<String> profileNames = new List<String>();
        
        for (PD_Review_Delegates__mdt d:delegatesList )
        {
            profileNames.add(d.Profile_Name__c);
        }
        
        List<Profile> profiles = [SELECT Id, Name from Profile WHERE Name in :profileNames];
        
        return profiles;
    }
    // read the custom metadate type called PD Review Delegates
    // It contains all the profiles that are allowed to edit reviews assigned to other people
    // compare the profile of the current user with one of the delegates
    // If there is a match, this method will return true
    private boolean currentUserIsADelegate(List<Profile> profiles)
    {        
        
        for(Profile p : profiles)
        {
            //System.Debug('--- delegate profile Id is  ' + p.Id + ' and name is ' + p.Name);
            if(UserInfo.getProfileId() == p.Id)
            {
                return true;
            }
        }
        
        
        return false;
    }
}