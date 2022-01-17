public with sharing class ShowPdfById {
    @AuraEnabled(cacheable=true)
    public static id getInvoiceFileId(Id idOpportunity){
        try {
           
            ContentDocumentLink cdl =[select Id from ContentDocumentLink where LinkedEntityId =:idOpportunity];
        return cdl.Id;
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}
