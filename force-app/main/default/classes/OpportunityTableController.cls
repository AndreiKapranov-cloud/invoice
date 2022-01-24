public with sharing class OpportunityTableController {
    public OpportunityTableController() {
 }
 
 @AuraEnabled(cacheable=true)
    public static List<Product2> getListOfProducts(String opportunityId){
       try {  
         List<OpportunityLineItem>oppProducts = [select Id,Product2Id from OpportunityLineItem where opportunityId =: opportunityId];
        
         List<Id>product2Ids = new List<Id>();
        
         


         for(OpportunityLineItem oppProd : oppProducts){
            product2Ids.add(oppProd.Product2Id);
         }
         
         List<Product2>product2s = [select Id,Name from Product2 where Id IN :product2Ids];

        
        return product2s;
    
      } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
       }
    }
}
