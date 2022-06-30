public with sharing class RelatedKitsController {
@AuraEnabled
    public static List<Kit_Locator__c> findKits (Id recordId) {
        List<Contact> participant = [SELECT Name FROM Contact WHERE Id=:recordId];
        List<Program_Participant__c> programs = [SELECT Id FROM Program_Participant__c WHERE Participant__c in :participant];
  		List<Kit_Locator__c> kits = [SELECT Id, Status__c, Program_Participant__r.Program_Name__c, Date_Ordered__c, Date_Resulted__c FROM Kit_Locator__c WHERE Program_Participant__c in :programs];
        return kits;
    }
    

}