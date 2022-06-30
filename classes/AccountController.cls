public class AccountController {
@AuraEnabled
    public static List <Account> fetchAccounts() {
        //Qyery 10 accounts
        List<Account> accList = [SELECT Id, Name, BillingState, 
                                    Website, Phone, Industry, Type from Account LIMIT 10];
        //return list of accounts
        return accList;
    }
    
    @AuraEnabled
    public static List <Kit_Locator__c> fetchKits() {
        //Qyery 10 kits
        List<Kit_Locator__c> kitList = [SELECT Id, Name, Status__c, Date_Ordered__c, Date_Resulted__c, Entered_By__c from Kit_Locator__c LIMIT 10];
        //return list of kits
        return kitList;
    }
}