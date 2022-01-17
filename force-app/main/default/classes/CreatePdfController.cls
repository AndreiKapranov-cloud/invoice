public with sharing class CreatePdfController {
    
    @AuraEnabled
    public static Id generatePdf(String idOpportunity){
        Blob strPdfBody = null;
        Attachment objAttach = new Attachment();
        try {
            Opportunity objOpportunity = [SELECT Name,Invoice_number__c FROM Opportunity WHERE Id = :idOpportunity LIMIT 1];
            PageReference objPagePdf = Page.Invoice;
            objPagePdf.getParameters().put('Id', idOpportunity);
            strPdfBody =  objPagePdf.getContent();

            ContentVersion objVersion = new ContentVersion();
            objVersion.ContentLocation = 'S';
         
            
            objVersion.PathOnClient = objOpportunity.Name +'.pdf';
           
            
           
            objVersion.Title = objOpportunity.Invoice_number__c;
            objVersion.VersionData = strPdfBody;
            insert objVersion;

            Id objDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:objVersion.Id].ContentDocumentId;
            ContentDocumentLink objDocumentLink = New ContentDocumentLink();
            objDocumentLink.LinkedEntityId = objOpportunity.Id;
            objDocumentLink.ContentDocumentId = objDocId;
            objDocumentLink.shareType = 'V';
            insert objDocumentLink;
            return objDocumentLink.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
