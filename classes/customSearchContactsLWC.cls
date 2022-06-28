public with sharing class customSearchContactsLWC {
    @AuraEnabled(cacheable=true)
    public static list<Contact> getContactList(string searchKey) {
        string searchKeyword = '%' + searchKey + '%';
		
       // create contact list to store search result 
        list<contact> contactListRecord = new list<Contact>();
     
	   // query contact records
        for(contact conObj : [Select id,Email,FirstName,LastName,Birthdate
                            From Contact
                            WHERE name LIKE : searchKeyword]){
           contactListRecord.add(conObj);
        }
        
         if(contactListRecord.size() == 0){
           //figure out exception here
         }
         
        return contactListRecord;
    }
}