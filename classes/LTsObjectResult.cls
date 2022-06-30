public with sharing class LTsObjectResult {
	@AuraEnabled
	public String errorMessage {get;set;}

	@AuraEnabled
	public String statusCode {get;set;}

	@AuraEnabled
	public sObject dataRecord {get;set;}
}