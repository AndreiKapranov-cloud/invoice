global with sharing class BirthdayBatch implements Database.Batchable<sObject>{
   
    global database.querylocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(
            'SELECT Id,FirstName,Email,Birthdate FROM Contact'
        );
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {    
      
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
          //  mail.setReplyTo('myemailservice@b-1upgtt71biacjbix8nd62zrhdet2t5g5wu0e6ryfxlflvypnbf.5j-45fhreay.ap27.apex.salesforce.com');
          //  mail.setSenderDisplayName('Andrei');
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
        global void finish(Database.BatchableContext BC){

        }
     /*  @AuraEnabled
       global static void executeBatchOneTime(){
           try {
            ID jobID = Database.executeBatch(new BirthdayBatch(),200); 
           } catch (Exception e) {
               throw new AuraHandledException(e.getMessage());
           }
       }*/




   /* @AuraEnabled
       global static void scheduleBatch(SchedulableContext ctx,String cronStr){
           try {
            BirthdayBatch bb = new BirthdayBatch();
           
            String jobID = System.schedule('Schedule Create Birthday Email', cronStr, bb); 
           } catch (Exception e) {
               throw new AuraHandledException(e.getMessage());
           }
       }*/
  
  
  
       /*@AuraEnabled
       global static void execute(SchedulableContext ctx){
           try {
            BirthdayBatch bb = new BirthdayBatch();
            String cronStr = '20 30 8 10 2 ?';
            String jobID = System.schedule('Schedule Create Birthday Email', cronStr, bb);
           } catch (Exception e) {
               throw new AuraHandledException(e.getMessage());
           }
        }*/
     
     
     
        /* @AuraEnabled
       global static void abortBatch(){
          try {
            
           CronTrigger ct = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name='Schedule Batch Job' and 
           State = 'Waiting'];     
           System.abortJob(ct.Id);           
         } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
         }
        }*/
        
        
        
        /*@AuraEnabled
         global static Boolean abortBatch() {
           try {
             List<CronTrigger> cronTriggers = [
               SELECT Id, CronExpression
               FROM CronTrigger
               WHERE CronJobDetail.Name = 'Schedule Batch Job'
               LIMIT 1
             ];
             CronTrigger cronTrigger = (cronTriggers.size() == 1)
               ? cronTriggers.get(0)
               : null;
             System.abortJob(cronTrigger.Id);
             return true;
           } catch (Exception e) {
             System.debug(e.getMessage());
             return false;
           }
         }*/
     }
        
 
   
    
    


