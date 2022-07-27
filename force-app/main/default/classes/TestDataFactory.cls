@isTest
public class TestDataFactory{
    public static Contact createContact(){
        Account acct = new Account(Name='SFDC Account');
    insert acct;
        Contact con = new Contact(
        Email = 'akapranov872@gmail.com',
        FirstName='Joe',
        LastName='Smith',
        Phone='415.555.1212',
        AccountId=acct.ID);
    insert con;
        return con;
    }
    public static Account createAccount(){
        Account acc = new Account(Name='Andrei');
        insert acc;
        return acc;
    }
    public static User createUser(){
	 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',FirstName = 'Test',LastName='Test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
   return u;
    }
    
    public static Opportunity createOpportunity(){
		Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.StageName = 'Prospecting'; 
        testOpportunity.CloseDate = System.today() + 10;
        
        insert testOpportunity;
        
		return testOpportunity;
	}  
    public static List<Opportunity> createOpportunitiesClosedWon(){
     List<Opportunity> opps = new List<Opportunity>();

        for (Integer i = 1; i <= 10; i++) {
            opps.add(new Opportunity(Name = 'Name ' + i,StageName = 'Closed Won',
        CloseDate = System.today()+1));
        }

        insert opps;
        
        return opps;
    }

    public static List<Account> createAccounts(){
     List<Account> accounts = new List<Account>();

        for (Integer i = 1; i <= 10; i++) {
            accounts.add(new Account(Name = 'Name ' + i));
        }

        insert accounts;
        
        return accounts;
    }
   /// public static PriceBookEntry createPriceBookEntry(){
   //     PriceBookEntry pBE = new PriceBookEntry()
   // }

     public static ContentVersion createContentVersion(){
        ContentVersion newContentVersion = new ContentVersion();
        Opportunity opp = [select Id,Invoice_number__c from Opportunity where Name =: 'Test Opportunity' ];
        newContentVersion.Title = opp.Invoice_number__c;
         
        newContentVersion.PathOnClient='/' + newContentVersion.Title + '.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            newContentVersion.VersionData=bodyBlob; 
            //content.LinkedEntityId=sub.id;
            newContentVersion.origin = 'H';

         insert newContentVersion;
        return newContentVersion;
     }
  
    public static List<OpportunityLineItem> CreateOpportunityProducts(Opportunity opp){
          
   // Opportunity opp = TestDataFactory.createOpportunity();
    Id pricebookId = Test.getStandardPricebookId();
     
    Product2 prod = new Product2(
    Name = 'Product X',
    ProductCode = 'Pro-X',
    isActive = true,
    Type__c = 'car'
    );
    insert prod;


     PricebookEntry pbEntry = new PricebookEntry(
     Pricebook2Id = pricebookId,
     Product2Id = prod.Id,
     UnitPrice = 100.00,
     IsActive = true
     );
     insert pbEntry;
        
     List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
     for (Integer i = 1; i <= 10; i++) {
         opportunityLineItems.add(new OpportunityLineItem(PricebookEntryId = pbEntry.Id,opportunityId = opp.Id,quantity = 10,totalPrice=100));
     }
     insert opportunityLineItems;       
     return opportunityLineItems;
     }
     public static OpportunityLineItem createOpportunityLineItem(){
     Product2 p = new Product2();
     p.Name = ' Test Product ';
     p.Description='Test Product Entry For Product';
     p.productCode = 'SFDCPanther-123';
     p.isActive = true;
     insert p;

// insert pricebook entry for the product
     PricebookEntry standardPrice = new PricebookEntry();
     standardPrice.Pricebook2Id = Test.getStandardPricebookId();
     standardPrice.Product2Id = p.Id;
     standardPrice.UnitPrice = 100;
     standardPrice.IsActive = true;
     standardPrice.UseStandardPrice = false;
     insert standardPrice ;

     // insert account
     Account acc = new Account(
     Name = 'SFDCPanther.com',
     Rating = 'Hot',
     Industry = 'Banking',
     Phone = '9087654321'
     );
     insert acc;

     Opportunity opp = new Opportunity();
     opp.AccountId = acc.Id;
     opp.Name = 'Test Opportunity';
     opp.CloseDate= System.Today();
     opp.StageName='Prospecting';
     opp.Pricebook2Id = Test.getStandardPricebookId();
     insert opp;

   
     OpportunityLineItem oppLineItem = new OpportunityLineItem();
     oppLineItem.OpportunityId = opp.Id;
     oppLineItem.PricebookEntryId = standardPrice.Id;
     oppLineItem.UnitPrice = 7000;
     oppLineItem.Quantity = 5;
     insert oppLineItem;
        return oppLineItem;
    }
    public static List<Product2> createProducts(){
        Product2 p = new Product2();
     p.Type__c = 'Car';
     p.Name = ' Test Product ';
     p.Description='Test Product Entry For Product';
     p.productCode = 'SFDCPanther-123';
     p.isActive = true;
     
        Product2 p1 = new Product2();
     p1.Type__c = 'Car';   
     p1.Name = ' Test Product1 ';
     p1.Description='Test Product Entry For Product1';
     p1.productCode = 'SFDCPanther-1234';
     p1.isActive = true;
     List<Product2> products = new List<Product2>();
     products.add(p);  
     products.add(p1);
     insert products;
     return products;
    }
}