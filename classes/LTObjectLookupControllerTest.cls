@isTest
private class LTObjectLookupControllerTest {

	@testSetup static void setup() {
		List<Lead> leads = new List<Lead>();

		Lead lead = new Lead(
		    FirstName = 'John',
		    LastName = 'Smith',
		    Company = 'Acme Widgets',
		    Phone = '9415551234',
		    Email = 'wiz@test.test'
		);
		leads.add(lead);

		Lead lead2 = new Lead(
		    FirstName = 'Bill',
		    LastName = 'Costigan',
		    Company = 'Citizens Bank',
		    Phone = '7188005544',
		    Email = 'bill@test.test'
		);
		leads.add(lead2);

		insert leads;
	}

	@isTest static void testSearchObject() {
		List<SObject> leads = LTObjectLookupController.getSObjectsByName('John', 'Lead', null, null, null);
		System.assertEquals(1, leads.size(), 'Expected 1 lead to be returned by search.');
	}

	/*

	@isTest static void testGetRecentRecords() {
		List<SObject> leads = LTObjectLookupController.getSObjectsByName(null, 'Lead', null, null, null);
		System.assertEquals(2, leads.size(), 'Expected 2 leads to be returned by search.');
	}

	*/

	@isTest static void testSearchObjectWithSearchFields() {
		List<String> searchFields = new List<String>();
		searchFields.add('Company');
		List<SObject> leads = LTObjectLookupController.getSObjectsByName('Acme', 'Lead', null, searchFields, null);
		System.assertEquals(1, leads.size(), 'Expected 1 lead to be returned by search.');
	}

	@isTest static void testSearchObjectWithSearchFieldsAndDisplay() {
		List<String> searchFields = new List<String>();
		searchFields.add('Company');
		List<String> displayFields = new List<String>();
		displayFields.add('Phone');
		List<SObject> leads = LTObjectLookupController.getSObjectsByName('Acme', 'Lead', null, searchFields, displayFields);
		System.assertEquals(1, leads.size(), 'Expected 1 lead to be returned by search.');
		System.assertEquals('9415551234', (String)leads[0].get('Phone'));
	}

	@isTest static void testSearchObjectNotFound() {
		try {
			List<SObject> leads = LTObjectLookupController.getSObjectsByName('John', 'LeadZZZZZZZZZ', null, null, null);
		} catch (LTObjectLookupController.LookupException e) {
			System.assert( e.getMessage().contains('The specified SObject does not exist'), 'Expected to not find SObject');
		}
	}

}