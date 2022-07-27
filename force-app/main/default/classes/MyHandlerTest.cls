@isTest
public class MyHandlerTest {
@isTest
  static void testInboundEmail(){
  Opportunity opp = TestDataFactory.createOpportunity();
  upsert opp;
    
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  // setup the data for the email
  email.subject = 'INV-000003';
  email.fromname = 'FirstName1 LastName1';
  email.fromAddress = 'test@gmail.com';
  email.plainTextBody = 'Approved'; 
  env.fromAddress = 'test@gmail.com';
    
 
  Myhandler emailProcess = new Myhandler();
   
  emailProcess.handleInboundEmail(email, env);
   
  }
  @isTest
  static void testInboundEmail1(){
  Opportunity opp = TestDataFactory.createOpportunity();

  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  
  Opportunity oppa = [select Invoice_number__c from Opportunity where Id =:opp.Id];  
  String invN = oppa.Invoice_number__c;
  email.subject = invN ;
  email.fromname = 'FirstName1 LastName1';
  email.fromAddress = 'test@gmail.com';
  email.plainTextBody = 'Rejected'; 
  env.fromAddress = 'test@gmail.com';
   
 
  MyHandler emailProcess = new MyHandler();
   
  emailProcess.handleInboundEmail(email, env);
   
    }
    @isTest
  static void testInboundEmail2(){
  Opportunity opp = TestDataFactory.createOpportunity();

  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  
  Opportunity oppa = [select Invoice_number__c from Opportunity where Id =:opp.Id];  
  String invN = oppa.Invoice_number__c;
  email.subject = invN ;
  email.fromname = 'FirstName1 LastName1';
  email.fromAddress = 'test@gmail.com';
  email.plainTextBody = 'Approved'; 
  env.fromAddress = 'test@gmail.com';
   
 
  MyHandler emailProcess = new MyHandler();
   
  emailProcess.handleInboundEmail(email, env);
   
    }
    @isTest
  static void testInboundEmail3(){
  Opportunity opp = TestDataFactory.createOpportunity();
  opp.StageName = 'Qualification';
  upsert opp;
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  
  Opportunity oppa = [select Invoice_number__c from Opportunity where Id =:opp.Id];  
  String invN = oppa.Invoice_number__c;
  email.subject = invN ;
  email.fromname = 'FirstName1 LastName1';
  email.fromAddress = 'test@gmail.com';
  email.plainTextBody = 'Approved'; 
  env.fromAddress = 'test@gmail.com';
   
 
  MyHandler emailProcess = new MyHandler();
  
  emailProcess.handleInboundEmail(email, env);
  opp.StageName = 'Needs Analysis';
  upsert opp;
  MyHandler emailProcess1 = new MyHandler();
  
  emailProcess1.handleInboundEmail(email, env);
  emailProcess.handleInboundEmail(email, env);
  
      
  opp.StageName = 'Value Proposition';
  upsert opp;
  MyHandler emailProcess2 = new MyHandler();
  
  emailProcess2.handleInboundEmail(email, env);
  Opportunity opp1 = [select Id,Stagename from Opportunity where Id =: opp.Id];
  System.assertEquals('Id. Decision Makers', opp1.Stagename);
 
  opp.StageName = 'Id. Decision Makers';
  upsert opp;
  MyHandler emailProcess3 = new MyHandler();
  
  emailProcess3.handleInboundEmail(email, env);
  Opportunity oppp = [select Id,Stagename from Opportunity where Id =: opp.Id];
  System.assertEquals('Perception Analysis', oppp.Stagename);
 
  
      
  
      
  opp.StageName = 'Perception Analysis';
  upsert opp;
  MyHandler emailProcess4 = new MyHandler();
  
  emailProcess4.handleInboundEmail(email, env);
  Opportunity opp4 = [select Id,Stagename from Opportunity where Id =: opp.Id];
  System.assertEquals('Proposal/Price Quote', opp4.Stagename);
 
      
      
  opp.StageName = 'Proposal/Price Quote';
  upsert opp;
  MyHandler emailProcess5 = new MyHandler();
  
  emailProcess5.handleInboundEmail(email, env);
  Opportunity opp5 = [select Id,Stagename from Opportunity where Id =: opp.Id];
  System.assertEquals('Negotiation/Review', opp5.Stagename);
   
  opp.StageName = 'Negotiation/Review';
  upsert opp;
  MyHandler emailProcess6 = new MyHandler();
  
  emailProcess6.handleInboundEmail(email, env);
  Opportunity opp6 = [select Id,Stagename from Opportunity where Id =: opp.Id];
  System.assertEquals('Closed Won', opp6.Stagename);
 
  }
    
  }