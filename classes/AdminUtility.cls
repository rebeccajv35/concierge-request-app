public class AdminUtility 
{
    //comma separated emails
     public static void sendEmailToAdmin(List<String> adminEmails, String subject,  String bodyMessage)
    {
        List<User> userList = [SELECT Id, Email from User WHERE Email in :adminEmails];
        System.Debug('num users in userList ' + userList.size());
            
        for(User u : userList)
        {
            System.debug('emailing user with email' + u.Email);
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            emailMsg.setTargetObjectId(u.Id);
            emailMsg.setSubject(subject);
            emailMsg.setPlainTextBody(bodyMessage);
            emailMsg.saveAsActivity = false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMsg });
            
        }

    }   
}