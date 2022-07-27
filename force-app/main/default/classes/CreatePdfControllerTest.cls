@isTest
public class CreatePdfControllerTest {
  @isTest static void generatePdfTestPositive(){
   
     Blob strPdfBody = null;
     Attachment objAttach = new Attachment();

     Opportunity opp = testDataFactory.createOpportunity();
     ContentVersion newContentVersion = testDataFactory.createContentVersion();
     Test.startTest();
    CreatePdfController.generatePdf(opp.Id);
     Test.stopTest();
     PageReference objPagePdf = Page.Invoice;
     objPagePdf.getParameters().put('Id', opp.Id);
     strPdfBody = blob.valueOf('Unit.Test');
     //strPdfBody =  objPagePdf.getContent();
     List <ContentVersion> unique = new List<ContentVersion>();
      
           
      ContentVersion objVersion = new ContentVersion();
      objVersion.ContentLocation = 'S';
           
      objVersion.PathOnClient = opp.Name +'.pdf';
         
      objVersion.Title = opp.Invoice_number__c;
            
      objVersion.VersionData = strPdfBody;
      insert objVersion;
            Id objDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:objVersion.Id].ContentDocumentId;
      ContentDocumentLink objDocumentLink = New ContentDocumentLink();
      objDocumentLink.LinkedEntityId =  opp.Id;
      objDocumentLink.ContentDocumentId = objDocId;
      objDocumentLink.shareType = 'V';
      insert objDocumentLink;
     
           
      CreatePdfController.generatePdf(opp.Id);
          
     
  }
      @isTest static void generatePdfTestNegative(){
         
      Blob strPdfBody = null;
      Attachment objAttach = new Attachment();

      Opportunity opp = testDataFactory.createOpportunity();
 
      Test.startTest();
            CreatePdfController.generatePdf(opp.Id);
      Test.stopTest();
      PageReference objPagePdf = Page.Invoice;
      objPagePdf.getParameters().put('Id', opp.Id);
      strPdfBody = blob.valueOf('Unit.Test');
         
      List <ContentVersion> unique = new List<ContentVersion>();
      
           
      ContentVersion objVersion = new ContentVersion();
      objVersion.ContentLocation = 'S';
           
      objVersion.PathOnClient = opp.Name +'.pdf';
         
      objVersion.Title = opp.Invoice_number__c;
            
      objVersion.VersionData = strPdfBody;
      insert objVersion;
            Id objDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:objVersion.Id].ContentDocumentId;
      ContentDocumentLink objDocumentLink = New ContentDocumentLink();
      objDocumentLink.LinkedEntityId =  opp.Id;
      objDocumentLink.ContentDocumentId = objDocId;
      objDocumentLink.shareType = 'V';
      insert objDocumentLink;
     
           
      CreatePdfController.generatePdf(opp.Id);
          
      
  }
}