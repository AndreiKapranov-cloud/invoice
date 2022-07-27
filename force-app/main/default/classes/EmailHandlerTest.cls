@isTest
public class EmailHandlerTest {
   @isTest public static void getOpportunityTest(){
        Contact con = TestDataFactory.createContact();
        con.Email = 'gggggg@gmail.com';
        upsert con;
        Opportunity opp = TestDataFactory.createOpportunity();
        
        
        Opportunity oppp = EmailHandler.getOpportunity(opp.Id);
        String invNum =EmailHandler.getInvoiceNumber(opp.Id);
       
        OpportunityContactRole opConRole = new OpportunityContactRole();
        opConRole.IsPrimary = true;
        opConRole.ContactId = con.Id;
        opConRole.OpportunityId = opp.Id;
        try{
        Contact cont = EmailHandler.getCon(opp.Id);
        System.assertEquals('gggggg@gmail.com', cont.Email);
        }
       catch(Exception e) {
        }
      
    }
    @isTest public static void getFailInvoiceNumber(){
        
        Opportunity opp = TestDataFactory.createOpportunity();
        try{
        String invNum =EmailHandler.getInvoiceNumber('00D5j0000045fHREAY');
         }
       catch(Exception e) {
        }
    }
     @isTest public static void getFailOpportunityTest(){
        Contact con = TestDataFactory.createContact();
        con.Email = 'gggggg@gmail.com';
        upsert con;
        try{
        Opportunity opp = TestDataFactory.createOpportunity();
        
        Opportunity oppp = EmailHandler.getOpportunity('00D5j0000045fHREAY');
        }
        catch(Exception e) {
        }
        
        }
    
     @isTest public static void getEmailTemplateTest(){
    EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00D5j0000045fHREAY', TemplateType= 'Text', Name = 'InvoiceTemplate'); 
    EmailTemplate s = EmailHandler.getEmailTemplate(); 
     }
    
    @isTest public static void getOpConRole(){
        
        Opportunity opp = TestDataFactory.createOpportunity();
        Contact contact = TestDataFactory.createContact();
        Account acc = TestDataFactory.createAccount();
        opp.AccountId = acc.Id;
        contact.AccountId = acc.Id;
        
        upsert opp;
        upsert contact;
        upsert acc;
        OpportunityContactRole ocp = new OpportunityContactRole();
        ocp.ContactId = contact.Id;
        ocp.OpportunityId = opp.Id;
        ocp.IsPrimary = true;
        insert ocp;
        
        Contact con = EmailHandler.getCon(opp.Id);
     
        OpportunityContactRole oCP2 = new OpportunityContactRole();
        oCP2.ContactId = con.Id;
        oCP2.OpportunityId = opp.Id;
        insert oCP2;
        try{
         String name = EmailHandler.getRecipientName(opp.Id);
        }
        catch(Exception e) 
        {}
        try{
         String address = EmailHandler.getAddress(opp.Id);
        }
        catch(Exception e) 
        {}
        try{
         String fName = EmailHandler.getRecipientFName(opp.Id);
        }
        catch(Exception e) 
        {}
          
    }
    @isTest public static void newTest(){
        Account acct = new Account(Name='SFDC Account');
        insert acct;
        
        EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00D5j0000045fHREAY', TemplateType= 'Text', Name = 'InvoiceTemplate'); 
        e.body = '{!Contact.FirstName}';
        e.subject = '{!Opportunity.Invoice_number__c}';
        
        String email = 'hkhkbkhmail.';
        
        List<String> toAddress = new List<String>();
        toAddress.add(email);
        
        String subject = 'subject';
        String body = 'body';
        
   
        Opportunity opp = TestDataFactory.createOpportunity();
        Contact contact = TestDataFactory.createContact();
        Account acc = TestDataFactory.createAccount();
        contact.AccountId = acc.Id;
        opp.AccountId = acc.Id;
       
        
        upsert opp;
        upsert contact;
        upsert acc;
        OpportunityContactRole ocp = new OpportunityContactRole();
        ocp.ContactId = contact.Id;
        ocp.OpportunityId = opp.Id;
        ocp.IsPrimary = true;
        insert ocp;
        
        Contact con = EmailHandler.getCon(opp.Id);
     
        OpportunityContactRole oCP2 = new OpportunityContactRole();
        oCP2.ContactId = con.Id;
        oCP2.OpportunityId = opp.Id;
        insert oCP2;
        
        try{
        EmailHandler.sendEmail(toAddress,subject,body,opp.Id);
        }
        catch(Exception ex) 
        {}   
        }
  
     
       @isTest public static void fileTest(){
       test.startTest();
       Opportunity objOpportunity = TestDataFactory.createOpportunity();
        
       
        PageReference pageRef = Page.Invoice;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',objOpportunity.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        Blob strPdfBody = Blob.valueof('Some random String');
        
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
          Id ofVersion = EmailHandler.getInvoiceFileId(objOpportunity.Id);
         
              test.stopTest();
        }
        @isTest public static void fileFailTest(){
        test.startTest();
        Opportunity objOpportunity = TestDataFactory.createOpportunity();
        
       
        PageReference pageRef = Page.Invoice;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',objOpportunity.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpportunity);
        Blob strPdfBody = Blob.valueof('Some random String');
        
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
          try{
          Id ofVersion = EmailHandler.getInvoiceFileId('00D5j0000045fHREAY');
           }
          catch(Exception e) {
        }
          test.stopTest();
        }
}