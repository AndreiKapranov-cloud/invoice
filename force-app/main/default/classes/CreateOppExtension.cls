public with sharing class CreateOppExtension {
    private final SObject parent;
    public List<OpportunityLineItem> oppProducts {get; set;}
    public List<Product2> products {get; set;}
     
    
    public User oppOwner{get;set;} 
    public Opportunity opp{get; set;}
    public OpportunityContactRole oppConRole {get; set;}
    public Contact oppConRoleContact {get; set;}
    public Account oppConRoleContactAccount {get; set;}
     
    public CreateOppExtension(){
        
    }
    
    public CreateOppExtension(ApexPages.StandardController controller) {
       parent = controller.getRecord();
          
       
        opp =[select Invoice_number__c,OwnerId from Opportunity where Id=:parent.Id LIMIT 1];
        oppConRole =[select Id,ContactId,isPrimary from OpportunityContactRole where opportunityId = :parent.id and isPrimary=true LIMIT 1];
          
        oppConRoleContact =[select Id,Name,Email,Phone,AccountId from Contact where Id =: oppConRole.ContactId LIMIT 1];
       
        oppConRoleContactAccount =[select Id,Name from Account where Id =: oppConRoleContact.AccountId LIMIT 1];
         
        oppProducts =[select Id,product2Id,Name,quantity,unitPrice,totalPrice,ProductName__c from OpportunityLineItem where opportunityId = :parent.id]; 
    
    
    }
        Decimal balanceDue = 0;   
        
    public Decimal getBalanceDue() {
       for(OpportunityLineItem oppProduct:oppProducts){
             balanceDue = balanceDue + oppProduct.TotalPrice;
        }
        return balanceDue;  
     }
       
    public String getOppOwnerName(){  
      //  User owner = [select Id,Name from User where Id=:opp.OwnerId LIMIT 1];
            return [select Id,Name from User where Id=:opp.OwnerId LIMIT 1].Name;
    }
  }