public with sharing class EmailHandler {
    @AuraEnabled
    public static void sendEmail(List<String> toAddress, String subject, String body,Id recordId) {      
       
        Messaging.reserveSingleEmailCapacity(1);
        try{
        messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        
        System.debug(toAddress);
        System.debug(body);
        System.debug(subject);
       
        EmailTemplate emailTemplate =[select Id,Subject,Body from EmailTemplate where name =
        'InvoiceTemplate'];
        String tempSubj = (emailTemplate.subject).replace('{!Opportunity.Invoice_number__c}', getInvoiceNumber(recordId));
        String tempBody = (emailTemplate.body).replace('{!Contact.FirstName}', getRecipientFName(recordId));
      
        Contact con = getCon(recordId);
         
        mail.setTemplateId(emailTemplate.Id);
        mail.setTargetObjectId(con.Id);
        mail.setWhatId(recordId);
        mail.setToAddresses(toAddress);       
        mail.setReplyTo('myemailservice@b-1upgtt71biacjbix8nd62zrhdet2t5g5wu0e6ryfxlflvypnbf.5j-45fhreay.ap27.apex.salesforce.com');
        mail.setSenderDisplayName('Your name here');
        mail.setSubject(tempSubj);
        mail.setEntityAttachments(new list<Id>{getInvoiceFileId(recordId)});
        if(String.isBlank(body)){
        mail.setHtmlBody(tempBody);
       
    }else{
        mail.setHtmlBody(body);
    }
        Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
 
  @AuraEnabled(cacheable=true)
  public static Opportunity getOpportunity(Id idOpportunity){
      try {
    //  Opportunity op = [select Id,Invoice_number__c from Opportunity where Id =: idOpportunity];
      return [select Id,Invoice_number__c from Opportunity where Id =: idOpportunity];
      } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
      }
  }
  @AuraEnabled(cacheable = true)
  public static EmailTemplate getEmailTemplate() {
      return [select Id,Subject,Body from EmailTemplate where name =
        'InvoiceTemplate'];
      }
  @AuraEnabled(cacheable=true)
  public static String getInvoiceNumber(Id idOpportunity){
      try {
  Opportunity opport =[select Id,Invoice_number__c from Opportunity where Id =:idOpportunity];
     // String invNumber = opport.Invoice_number__c;
      return opport.Invoice_number__c;
        
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
   //  Contact con = getCon(idOpportunity);
    return getCon(idOpportunity).FirstName; 
    } catch (Exception e) {
    throw new AuraHandledException(e.getMessage());
     }
    }
    @AuraEnabled(cacheable=true)
    public static string getRecipientName(Id idOpportunity){
        try {
         //   Contact con = getCon(idOpportunity);
            return getCon(idOpportunity).Name; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static string getAddress(Id idOpportunity){
        try {
        //    Contact con = getCon(idOpportunity);
            return getCon(idOpportunity).Email;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Id getInvoiceFileId(Id recordId){
        try {
        ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
       
      //  ContentVersion docVersion = [SELECT ContentDocumentId, FileExtension, Title 
       // FROM ContentVersion WHERE ContentDocumentId =: cdl.ContentDocumentId AND FileExtension='pdf' AND IsLatest = true];
        return [SELECT ContentDocumentId, FileExtension, Title 
         FROM ContentVersion WHERE ContentDocumentId =: cdl.ContentDocumentId AND FileExtension='pdf' AND IsLatest = true].Id;  
        } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        }
    }
}