global with sharing class Crossroad implements Schedulable {
 
  String jobName = 'Schedule Batch Job';
  
  @AuraEnabled
    global static void scheduleBatch(String cron,String schedulableClassName,String batchableClassName){
      try {
        Type newSchedulerType = Type.forName(schedulableClassName);

      // (Schedulable) JSON.deserialize(JSON.serialize(new Map<String, Object>{'batchableClassName' => batchableClassName}), newSchedulerType)
       
       
        // String jobID = System.schedule('Schedule Batch Job', cron, (Schedulable)newSchedulerType.newInstance());
 

       
       
       
        String jobID = System.schedule('Schedule Batch Job', cron,
         (Schedulable) JSON.deserialize(JSON.serialize
          (new Map<String, Object>{'batchableClassName' => batchableClassName}), newSchedulerType));
   // (Schedulable)newSchedulerType.newInstance() =(Schedulable) JSON.deserialize(JSON.serialize(new Map<String, Object>{'batchableClassName' => batchableClassName}), newSchedulerType)





      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
    global void execute(SchedulableContext ctx ) {

    }
    @AuraEnabled
       global static void executeBatchOneTime(String batchableClassName){
           try {
            Type newBatchType = Type.forName(batchableClassName);
            ID jobID = Database.executeBatch((Database.Batchable<sObject>)newBatchType.newInstance(),200); 
           } catch (Exception e) {
               throw new AuraHandledException(e.getMessage());
           }
       }
      
      
      
      
      
      
      
      
       @AuraEnabled
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
       }
    
 //   Type newSchedulerType = Type.forName('schedulableClassName');
//System.schedule('Job Name', CRONstr, (Schedulable)newSchedulerType.newInstance());
 //   Type newBatchType = Type.forName('batchableClassName');
//System.schedule('Job Name', CRONstr, (Schedulable)newSchedulerType.newInstance());




/*global database.querylocator start(Database.BatchableContext BC)
    {}
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {   }
    global void finish(Database.BatchableContext BC){

    }*/
}
