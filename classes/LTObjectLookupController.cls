public with sharing class LTObjectLookupController {

	/**
	 * Retrieves search for specified SObject and Search String
	 * @param  searchString Name of Record to search for
	 * @param  sObjectName  API Name of SObject to search on
	 * @return              List of <Sobjects> returned by search
	 */
	@AuraEnabled
	public static List<SObject> getSObjectsByName(String searchString, String sObjectName, String whereClause, List<String> searchFields, List<String> displayFields) {
		sObjectName = String.escapeSingleQuotes(sObjectName);
		searchString = String.escapeSingleQuotes(String.isBlank(searchString) ? '' : searchString);

		System.debug(searchFields);
		
		if ( !hasSobject(sObjectName) ) {
			//throw an error
			throw new LookupException('The specified SObject does not exist: ' + sObjectName);
		}

		String additionalFields = '';
		if(displayFields != null && !displayFields.isEmpty()){
			additionalFields = ',' + String.join(displayFields, ',');
		}

		String query = 'SELECT Id, Name '+additionalFields+' FROM ' + sObjectName;
		if ( String.isNotBlank(searchString) ) {
			Integer index = 1;
			if( searchFields != null && searchFields.size() > 0){

				query += ' WHERE (';
				for( String queryField : searchFields){
					query += queryField + ' LIKE \'%' + searchString + '%\' ';
					if( index != searchFields.size() ){
						query += ' OR ';
					}
					index++;
				}
				query += ' ) ';
				 SYSTEM.DEBUG('1: ' + query);
			} else {
				query += ' WHERE Name LIKE \'%' + searchString + '%\' ';
                 SYSTEM.DEBUG('2: ' + query);
			}
            
           
			if(String.isNotBlank(whereClause)){
                whereClause = whereClause.replace('undefined', '');
				query += whereClause;
			}
             SYSTEM.DEBUG('3: ' + query);
		} 
	
		query += ' ORDER BY Name LIMIT 5';
		SYSTEM.DEBUG('5: ' + query);
		return Database.query(query);
	}

	/**
	 * Checks if the org has the SObject
	 * @param  sObjectName API Name of the SObject to check against
	 * @return             True/False
	 */
	private static Boolean hasSobject(String sObjectName) {
		Map<String, Schema.SObjectType> d = Schema.getGlobalDescribe();
		if ( !d.containsKey(sObjectName) ) {
			return false;
		}
		return true;
	}

	public class LookupException extends Exception {}
}