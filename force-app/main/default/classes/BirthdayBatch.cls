public with sharing class BirthdayBatch implements Database.Batchable<sObject>{
   // public void execute(System.SchedulableContext ctx){}
    public database.querylocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(
            'SELECT Id,FirstName,Email,Birthdate FROM Contact'
        );
    }
    public void execute(Database.BatchableContext BC, List<Contact> scope)
    {    
 // @AuraEnabled
  //      public static void sendEmail(List<String> toAddress, String subject, String body,Id recordId) {      
          for(Contact con : scope) {
             if(con.Birthdate == Date.today()){
          
            Messaging.reserveSingleEmailCapacity(1);
            try{
            messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        
            EmailTemplate emailTemplate =[select Id,Subject,Body from EmailTemplate where name =
            'BirthdayTemplate'];
            String tempBody = (emailTemplate.body).replace('{!Contact.FirstName}',con.FirstName);
            List<String>toAdressList = new List<String>();
            toAdressList.add(con.Email);
            //Contact con = getCon(recordId);
             
            mail.setTemplateId(emailTemplate.Id);
            mail.setTargetObjectId(con.Id);
         //   mail.setWhatId(recordId);
            mail.setToAddresses(toAdressList);       
            mail.setReplyTo('myemailservice@b-1upgtt71biacjbix8nd62zrhdet2t5g5wu0e6ryfxlflvypnbf.5j-45fhreay.ap27.apex.salesforce.com');
            mail.setSenderDisplayName('Andrei');
            mail.setSubject(emailTemplate.subject);
            
            mail.setHtmlBody(tempBody);
           
            Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
            }
            catch (exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
        }
        public void finish(Database.BatchableContext BC){}
        
    }
    


