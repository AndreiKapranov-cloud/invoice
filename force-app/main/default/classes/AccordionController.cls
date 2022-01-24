public with sharing class AccordionController {
    public AccordionController() {
}
   @AuraEnabled(cacheable=true)
   public static List<Account>  retriveAccounts(){
   return [select Id,Name,NamePlusOppClosedWon__c,OpportunitiesClosedWon__c from Account];

}
   @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(String accountId){
   return [select Id,AccountId,Name,CreatedDate,CloseDate,Amount from Opportunity
    where StageName = 'Closed Won' AND AccountId =: accountId];    
    }  
   
    @AuraEnabled( cacheable = true )  
    public static List< Account > fetchAccountsByName( String searchKey ) {  
   
     String strKey = '%' + searchKey + '%';  
     return [ SELECT Id,Name,NamePlusOppClosedWon__c,OpportunitiesClosedWon__c FROM Account WHERE Name LIKE: strKey LIMIT 10 ];  
       
    }  
    @AuraEnabled( cacheable = true )  
    public static List< Account > fetchAccountsByNum( String searchKey ) {  
   
     return [ SELECT Id,Name,NamePlusOppClosedWon__c,OpportunitiesClosedWon__c FROM Account WHERE OpportunitiesClosedWon__c >: (integer.valueof(searchKey)-5) AND OpportunitiesClosedWon__c <: (integer.valueof(searchKey)+5) LIMIT 10 ];  
       
 }  
}


