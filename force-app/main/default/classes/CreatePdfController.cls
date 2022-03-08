public with sharing class CreatePdfController {
    
    @AuraEnabled
    public static Id generatePdf(String idOpportunity){
    Blob strPdfBody = null;
    Attachment objAttach = new Attachment();

    try {
      Opportunity objOpportunity = [SELECT Id,Name,Invoice_number__c FROM Opportunity WHERE Id = :idOpportunity LIMIT 1];
      PageReference objPagePdf = Page.Invoice;
      objPagePdf.getParameters().put('Id', idOpportunity);
      
      
      
      if(Test.isRunningTest()){
        strPdfBody = blob.valueOf('Unit.Test');
    }else{
        strPdfBody =  objPagePdf.getContent();}
      

      List <ContentVersion> unique = 
      [select Id,ContentDocumentId from ContentVersion where Title =: objOpportunity.Invoice_number__c ]; 
      if(unique.isEmpty()){
           
      ContentVersion objVersion = new ContentVersion();
      objVersion.ContentLocation = 'S';
           
      objVersion.PathOnClient = objOpportunity.Name +'.pdf';
         
      objVersion.Title = objOpportunity.Invoice_number__c;
            
      objVersion.VersionData = strPdfBody;
      insert objVersion;

      Id objDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:objVersion.Id].ContentDocumentId;
      ContentDocumentLink objDocumentLink = New ContentDocumentLink();
      objDocumentLink.LinkedEntityId =  objOpportunity.Id;
      objDocumentLink.ContentDocumentId = objDocId;
      objDocumentLink.shareType = 'V';
      insert objDocumentLink;
      return objDocumentLink.Id;
        
      }else{
      ContentVersion uniq = unique[0];
      Id objDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: uniq.Id].ContentDocumentId;
      ContentVersion newVersion = new ContentVersion();
      newVersion.ContentLocation = 'S';
           
      newVersion.PathOnClient = objOpportunity.Name +'.pdf';
         
      newVersion.VersionData = strPdfBody;
      newVersion.ContentDocumentId = objDocId;
           
      insert newVersion;
      return newVersion.Id;
       }
      } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
    }
   }
}