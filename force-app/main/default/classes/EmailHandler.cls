public with sharing class EmailHandler {
    @AuraEnabled
    public static void sendEmail(List<String> toAddress, String subject, String body,Id recordId) {      
       
        Messaging.reserveSingleEmailCapacity(1);
        try{
        messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        
        System.debug(toAddress);
        System.debug(body);
        System.debug(subject);
        // toAddress.add('er.rajat15@gmail.com');
       
        EmailTemplate emailTemplate =[select Id,Subject,Body from EmailTemplate where name =
        'Sissy'];
          String tempSubj = (emailTemplate.subject).replace('{!Opportunity.Invoice_number__c}', getInvoiceNumber(recordId));
          String tempBody = (emailTemplate.body).replace('{!Contact.FirstName}', getRecipientFName(recordId));
       //   tempSubj = tempSubj.replace('{!Opportunity.Invoice_number__c}', getInvoiceNumber(recordId));




          Contact con = getCon(recordId);
         
          mail.setTemplateId(emailTemplate.Id);
          
          mail.setTargetObjectId(con.Id);
          mail.setWhatId(recordId);
       
        mail.setToAddresses(toAddress);       
        mail.setReplyTo(userinfo.getUserEmail());
        mail.setSenderDisplayName('Your name here');
        mail.setSubject(tempSubj);
        mail.setEntityAttachments(new list<Id>{getInvoiceFileId(recordId)});
        if(String.isBlank(body)){
        mail.setHtmlBody(tempBody);
         //new list<Id> {
    }else{
        mail.setHtmlBody(body);
    }
        // mail.setEntityAttachments(files);
        Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
        
    }
 /* @AuraEnabled
  public static string getInvoiceNumber(idOpportunity) {
Opportunity opp = [select Id,Invoice_number__c from Opportunity where Id = :OpportunityId];
String InvNum = opp.Invoice_number__c;
return InvNum;
  }*/
  @AuraEnabled(cacheable=true)
  public static Opportunity getOpportunity(Id idOpportunity){
      try {
          Opportunity op = [select Id,Invoice_number__c from Opportunity where Id =: idOpportunity];
     return op;
        } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
  }
   @AuraEnabled(cacheable = true)
    public static EmailTemplate getEmailTemplate() {
        return [select Id,Subject,Body from EmailTemplate where name =
        'Sissy'];
    }
    @AuraEnabled(cacheable=true)
    public static string getInvoiceNumber(Id idOpportunity){
        try {
            Opportunity opport =[select Id,Invoice_number__c from Opportunity where Id =:idOpportunity];
        String invNumber = opport.Invoice_number__c;
        return invNumber;
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    public static Contact getCon(Id idOpportunity){
    OpportunityContactRole opConRole = [select Id,ContactId from OpportunityContactRole where OpportunityId =:idOpportunity and isPrimary = true];
            return [select Id,Name,FirstName,Email from Contact where Id = :opConRole.ContactId];
    }
    @AuraEnabled(cacheable=true)
    public static string getRecipientFName(Id idOpportunity){
        try {
            Contact con = getCon(idOpportunity);
            return con.FirstName; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static string getRecipientName(Id idOpportunity){
        try {
            Contact con = getCon(idOpportunity);
            return con.Name; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static string getAddress(Id idOpportunity){
        try {
            Contact con = getCon(idOpportunity);
            return con.Email;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        // Get record file IDs        
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        // Filter PDF files 
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
            FROM ContentVersion WHERE ContentDocumentId IN : fileIDs AND FileExtension='pdf'];
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
        }

        return mapIdTitle;
    }
    @AuraEnabled(cacheable=true)
    public static Id getInvoiceFileId(Id recordId){
        try {

            ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
       
        // Filter PDF files 
        ContentVersion doc = [SELECT ContentDocumentId, FileExtension, Title 
            FROM ContentVersion WHERE ContentDocumentId =: cdl.ContentDocumentId AND FileExtension='pdf'];
        
        
            return doc.Id;
        
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
}
}