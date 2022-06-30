public with sharing class LightningUtil {
	@AuraEnabled
	public static Map<String, String> getPicklistValues(String sObjectAPIName, String picklistName){
		Map<String, String> picklistOptions = new Map<String, String>();
		SObjectType sObjectName = Schema.getGlobalDescribe().get(sObjectAPIName);
		if(sObjectName == null) return picklistOptions;

		Schema.SObjectField field = sObjectName.getDescribe().fields.getMap().get(picklistName);
		if( field == null ) return picklistOptions;

		Schema.DescribeFieldResult fieldResult = field.getDescribe();

		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry f : ple){
			picklistOptions.put(f.getLabel(), f.getValue());
		}
		System.debug(picklistOptions);
		return picklistOptions;
	}
}