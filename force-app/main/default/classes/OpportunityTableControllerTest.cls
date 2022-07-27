@isTest
public class OpportunityTableControllerTest {
 @isTest static void getListOfProducts() {
 OpportunityTableController oTC = new OpportunityTableController();
     List<Product2> prodList = new List<Product2>();
     Product2 prod1 = new Product2(
     Name = 'Product XO',
     ProductCode = 'Pro-XO',
     isActive = true,
     Type__c = 'car'
     );
     Product2 prod2= new Product2(
     Name = 'Product X',
     ProductCode = 'Pro-X',
     isActive = true,
     Type__c = 'car'
     );
     prodList.add(prod2);
     prodList.add(prod1);
     insert prodList;
 
     Id pricebookId = Test.getStandardPricebookId(); 
   
     PricebookEntry pbEntry1 = new PricebookEntry(
     Pricebook2Id = pricebookId,
     Product2Id = prod2.Id,
     UnitPrice = 100.00,
     IsActive = true
     );
     PricebookEntry pbEntry2 = new PricebookEntry(
     Pricebook2Id = pricebookId,
     Product2Id = prod1.Id,
     UnitPrice = 100.00,
     IsActive = true
     );
     insert pbEntry1;
     insert pbEntry2;
     Opportunity opp = TestDataFactory.createOpportunity();
  
     OpportunityLineItem opPr1 = new OpportunityLineItem(PricebookEntryId = pbEntry1.Id,opportunityId = opp.Id,quantity = 10,totalPrice=100);
     insert opPr1;
     OpportunityLineItem opPr2 = new OpportunityLineItem(PricebookEntryId = pbEntry2.Id,opportunityId = opp.Id,quantity = 10,totalPrice=100);
     insert opPr2;
      
     List<Product2>product2s =OpportunityTableController.getListOfProducts(opp.Id) ; 
     System.Assert(product2s != null);
     List<Product2>product23 =OpportunityTableController.getListOfProducts('hgkjh86t');
     System.Assert(product23 != null);   
 }
     
}