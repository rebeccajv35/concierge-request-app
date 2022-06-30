//System.schedule('Hourly', '0 0 * * * ?', new OpportunityCleanupSchedulable() );  
//every hour on the 30 minute mark
//String cronStr = '0 50 * * * ?';
//every Sunday at around midnight
//cronStr = '0 59 23 ? * SUN';
//System.schedule('Oppty Scheduled Job', cronStr, new OpportunityCleanupSchedulable() ); 


public class OpportunityCleanupSchedulable implements Schedulable{
    
    String [] emailList = new String[]{};
    Boolean sendEmail = false;
    
    
    public void execute(SchedulableContext SC)
    {
        readConfig();
        cleanUpActiveAccountLookup();
    }
    
    // Once a week find all opportunities with 
    // probability = 0% OR  
    // (prob = 100% and close date < ( today - 365 days)) AND active account != null 
    // For these oportunities:set active account = null
    private void cleanUpActiveAccountLookup()
    {
        Integer numOps = 0;
        
        List<Opportunity> ops = [SELECT id, probability, closedate, active_account__c 
                                 FROM opportunity
                                 WHERE (probability = 0 OR 
                                        (probability = 100 and CloseDate < LAST_N_DAYS:365))
                                 AND active_account__c !=  null
                                ];
        
        numOps = ops.size();
        
        system.debug('updating ' + numOps + ' opportunities');
        
        for(Opportunity o : ops)
        {
            System.Debug('probability ' + o.probability + ' and close date ' + o.closedate);
            o.Active_Account__c = null;
        }
        
        update ops;
        
        //List<String> adminEmails = new List<String> ();
        //adminEmails.add('singhbhavana8@gmail.com');
        String subject = 'OpportunityCleanupSchedulable Ran';
        String body = 'Updated ' + numOps + ' Opportunities';
        if(sendEmail)
        {
            AdminUtility.sendEmailToAdmin(emailList, subject, body);
        }
        
    }
   
    private void readConfig()
    {
        Admin_Config__mdt  config = [SELECT EmailList__c, Send_Email__c 
                                            FROM Admin_Config__mdt
                                       		WHERE label = 'OpportunitySchedulableConfig'
                                       		LIMIT 1];  
        
        System.Debug('admin emails ' + config.EmailList__c);

        if(config.EmailList__c != null)
        {
            emailList = config.EmailList__c.split(',');
        }
        
        sendEmail = config.Send_Email__c;
        
        system.debug('send email ' + sendEmail);
        
    }
}