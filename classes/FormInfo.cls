public class FormInfo {

    
    String [] toEmails {get; private set;}
    String email {get; private set;}
    String phone {get; private set;}
    String addressLine1;
    String addressLine2;
    String [] address {get; private set;}
    public FormInfo()
    {
         // TBD change the name of the custom meta data type to be more generic
         Ad_Hoc_Order_Data__mdt info = [SELECT Address_Line_1__c, Address_Line_2__c, Email__c, Phone_Number__c, sandbox_To_Email__c, To_Email__c
                                            FROM Ad_Hoc_Order_Data__mdt
                                       		WHERE label = 'info'
                                       		LIMIT 1];  
        
        
        if(runningInSandbox()){toEmails = info.sandbox_To_Email__c.split(',');}else{toEmails = info.To_Email__c.split(',');  }
        
        email = info.Email__c;
        phone = info.Phone_Number__c;
        addressLine1 = info.Address_Line_1__c;
        addressLine2 = info.Address_Line_2__c;
        
        System.Debug('to EMails = ' + toEmails);
    }
    
    public  String [] getToEmails(){return toEmails;}
    public  String getEmail(){return email;}
    public  String getPhone(){return phone; }
    public String[] getAddress(){return new String[] {addressLine1 + '<br/>', addressLine2 + '</td></tr>'};}
	public String getAddressLine1(){return addressLine1;}
    public String getAddressLine2(){return addressLine2;}
    public static Boolean runningInSandbox(){return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;}

}