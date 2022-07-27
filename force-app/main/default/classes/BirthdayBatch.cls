global with sharing class BirthdayBatch implements Database.Batchable<sObject>{
   
    global database.querylocator start(Database.BatchableContext BC)
    {
        Date today = System.today();
        Integer day = today.day(); 
        Integer month = today.month();
        return Database.getQueryLocator(
            'SELECT Id,FirstName,Email FROM Contact where CALENDAR_MONTH(Birthdate) = :month and DAY_IN_MONTH(Birthdate) = :day'
        );
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {  
        try{
        List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
        Messaging.reserveSingleEmailCapacity(1);
        EmailTemplate emailTemplate =[select Id,Subject,Body from EmailTemplate where name =
            'BirthdayTemplate'];
         for(Contact con : scope) {
                 
            Messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage(); 
            String tempBody = (emailTemplate.body).replace('{!Contact.FirstName}',con.FirstName);
            List<String>toAdressList = new List<String>();
            toAdressList.add(con.Email);                    
            mail.setTemplateId(emailTemplate.Id);
            mail.setTargetObjectId(con.Id);          
            mail.setToAddresses(toAdressList);                 
            mail.setSubject(emailTemplate.subject);          
            mail.setHtmlBody(tempBody);  
            
            EmailList.add(mail);             
            }
            Messaging.sendEmail(EmailList);
        }
            catch (exception e){
                throw new AuraHandledException(e.getMessage());
            }         
        }
        global void finish(Database.BatchableContext BC){
        }   
     }