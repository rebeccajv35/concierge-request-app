// test the following classes and triggers
// OpportunityLineItemTrigger
// OppLineItemTriggerHandler
// OpportunityTrigger
// OpportunityTriggerHandler
@isTest
public class OpportunityTest {
    
    static testMethod void testOppLineItemDelete()
    {
        Account testAcc1 = new Account(Name = 'Test Acc1');
        insert testAcc1;
        
        //-----
        Product2 prod = new Product2(Name = 'Test product', productcode='test123');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
                // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
                
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp1', AccountId = testAcc1.Id, 
                                               Type = 'New Business', 
                                               Vertical__c = 'Healthplan', 
                                               StageName = 'Evaluation', 
                                               Sales_Step__c = 'Business Planning - 1%', 
                                               Product_Category__c = 'BioIQ Star', 
                                               CloseDate = Date.newInstance(2020,1,1), 
                                               LeadSource = 'Prospecting (Self)', 
                                               Deal_Lives__c = 1500);
        testOpp1.Pricebook2Id = customPB.Id; //pbook.Id;
        insert testOpp1;
        
        //Process builder is setting the PB to HealthPlan - need to reset it here
        testOpp1.Pricebook2Id = customPB.Id;
        update testOpp1;
        
        OpportunityLineItem oppProd = new OpportunityLineItem();
        oppProd.OpportunityId = testOpp1.id;
        oppProd.Product2Id = prod.Id;
        oppProd.quantity = 20;
        oppProd.TotalPrice = 2500.00;
        oppProd.Participation_Rate__c = 1;
        oppProd.PricebookEntryId = customPrice.Id;
        insert oppProd; 
        
        Test.startTest();
        
        List<Monthly_Revenue__c> mrList = [SELECT Id FROM Monthly_Revenue__C];
		//system.assert(mrList.size() > 0);        
        
        delete oppProd;
        
        mrList = [SELECT Id FROM Monthly_Revenue__C];
		//system.assertEquals(0, mrList.size());        
        Test.stopTest();
    }
    
    static testMethod void testOppDelete()
    {
        Account testAcc1 = new Account(Name = 'Test Acc1');
        insert testAcc1;
        
        Product2 prod = new Product2(Name = 'Test product', productcode='test123');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
                // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
                
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp1', AccountId = testAcc1.Id, 
                                               Type = 'New Business', 
                                               Vertical__c = 'Healthplan', 
                                               StageName = 'Evaluation', 
                                               Sales_Step__c = 'Qualified Lead', 
                                               Product_Category__c = 'BioIQ Star', 
                                               CloseDate = Date.newInstance(2020,1,1), 
                                               LeadSource = 'Prospecting (Self)', 
                                               Deal_Lives__c = 1500);
        testOpp1.Pricebook2Id = customPB.Id; //pbook.Id;
        insert testOpp1;
        
        //Process builder is setting the PB to HealthPlan - need to reset it here
        testOpp1.Pricebook2Id = customPB.Id;
        update testOpp1;
        
        
        OpportunityLineItem oppProd = new OpportunityLineItem();
        oppProd.OpportunityId = testOpp1.id;
        oppProd.Product2Id = prod.Id;
        oppProd.quantity = 20;
        oppProd.TotalPrice = 2500.00;
        oppProd.Participation_Rate__c = 1;
        oppProd.PricebookEntryId = customPrice.Id;
        insert oppProd; 
        
        Test.startTest();
        
        List<Monthly_Revenue__c> mrList = [SELECT Id FROM Monthly_Revenue__C];
		//system.assert(mrList.size() > 0);        
        
        delete testOpp1;
        
        mrList = [SELECT Id FROM Monthly_Revenue__C];
		system.assertEquals(0, mrList.size());        
        Test.stopTest();
    }
    
        static testMethod void testOppClosedLost()
    {
        Account testAcc1 = new Account(Name = 'Test Acc1');
        insert testAcc1;
        
        Product2 prod = new Product2(Name = 'Test product', productcode='test123');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
                // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
                
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp1', AccountId = testAcc1.Id, 
                                               Type = 'New Business', 
                                               Vertical__c = 'Healthplan', 
                                               StageName = 'Evaluation', 
                                               Sales_Step__c = 'Qualified Lead', 
                                               Product_Category__c = 'BioIQ Star', 
                                               CloseDate = Date.newInstance(2020,1,1), 
                                               LeadSource = 'Prospecting (Self)', 
                                               Deal_Lives__c = 1500);
        testOpp1.Pricebook2Id = customPB.Id; //pbook.Id;
        insert testOpp1;
        
                
        //Process builder is setting the PB to HealthPlan - need to reset it here
        testOpp1.Pricebook2Id = customPB.Id;
        update testOpp1;
        
        OpportunityLineItem oppProd = new OpportunityLineItem();
        oppProd.OpportunityId = testOpp1.id;
        oppProd.Product2Id = prod.Id;
        oppProd.quantity = 20;
        oppProd.TotalPrice = 2500.00;
        oppProd.Participation_Rate__c = 1;
        oppProd.PricebookEntryId = customPrice.Id;
        insert oppProd; 
        
        Test.startTest();
        
        List<Monthly_Revenue__c> mrList = [SELECT Id FROM Monthly_Revenue__C];
		//system.assert(mrList.size() > 0);        
        
        testOpp1.StageName = 'Closed Lost';
        testOpp1.Sales_Step__c = 'N/A';
        testOpp1.Closed_Lost_Comments__c = 'too expensive';
		update testOpp1;
        
        mrList = [SELECT Id FROM Monthly_Revenue__C];
		//system.assertEquals(0, mrList.size());        
        Test.stopTest();
    }

}