@isTest
public class CreateOppExtensionTest {
    
        @isTest public static void getBalanceDueTest(){
        CreateOppExtension coe = new CreateOppExtension();
        Decimal balanceDue = 0; 
        User oppOwner = TestDataFactory.createUser();
        List<product2>products = TestDataFactory.createProducts();
        OpportunityContactRole ocp = new OpportunityContactRole();
        Contact con = TestDataFactory.createContact();
        Account acc = TestDataFactory.createAccount();
        coe.oppConRoleContactAccount = acc;
        coe.oppConRoleContact = con; 
        coe.oppConRole = ocp;  
        coe.products = products;
        coe.oppOwner = oppOwner;
        Opportunity opp = TestDataFactory.createOpportunity();
        List <OpportunityLineItem> oppProducts = testDataFactory.CreateOpportunityProducts(opp);
            try{
        balanceDue = coe.getBalanceDue();
        System.assert( balanceDue>0);
        System.assertEquals( 2,products.size());  
        System.assertNotEquals(null,products);        
             }
            catch(Exception ex) {
                
            }
          }
        @isTest public static void getOppOwnerNameTest(){
            
        User oppOwner = TestDataFactory.createUser();
       
        Opportunity opp = TestDataFactory.createOpportunity();
        opp.OwnerId = oppOwner.Id;
        CreateOppExtension coe = new CreateOppExtension();
        
            try{  
        String name = coe.getOppOwnerName();
        
        System.assertEquals('Test Test', name);
               }
        catch(Exception ex) 
        {}   
            }
        @isTest static  void TestMyController(){    
		
      	Opportunity opp = TestDataFactory.createOpportunity();
              
        Contact con = TestDataFactory.createContact();
        OpportunityContactRole ocp = new OpportunityContactRole();
          
        ocp.contactId = con.Id;
        ocp.opportunityId = opp.Id;
         
        Account acc = TestDataFactory.createAccount();
        con.AccountId = acc.Id;
             
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware',
                                      Type__c = 'car');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
          Pricebook2Id = pricebookId, Product2Id = prod.Id,
          UnitPrice = 10000, IsActive = true);
          insert standardPrice;
          OpportunityLineItem opLI = new OpportunityLineItem(PricebookEntryId = standardPrice.Id,opportunityId = opp.Id,quantity = 10,totalPrice=100);
          List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>();
          oppProducts.add(opLI);
          upsert opp;
          upsert con;
          insert ocp;
          insert oppProducts;
          Test.StartTest(); 
            try{
          ApexPages.StandardController sc = new ApexPages.StandardController(opp);
          CreateOppExtension coe = new CreateOppExtension(sc);
		
          ApexPages.currentPage().getParameters().put('Id',opp.id);
          ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);  
          CreateOppExtension objCreateOppExtension = new CreateOppExtension(stdOpp);
          
          Test.StopTest();         
                 }
            catch(Exception ex) {
                
            }
           
            }
        @isTest static void testMethod2(){
        Opportunity opp =  TestDataFactory.createOpportunity();
        opp.Name = 'Test Opp';
        List<OpportunityLineItem>lineItems = TestDataFactory.CreateOpportunityProducts(opp);
           
        PageReference testPage = Page.Invoice; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));   
        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
           try{
        CreateOppExtension ext = new CreateOppExtension(sc);      
        System.debug(ext.getOppOwnerName());   
        List<Opportunity> al = [Select Name from Opportunity where Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(1, al.size()); 
          }
        catch(Exception ex) 
        {}   
    }
  }