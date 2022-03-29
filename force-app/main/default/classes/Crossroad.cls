global with sharing class Crossroad implements Schedulable {
 
 
  
  @AuraEnabled
    global static void scheduleBatch(String cron,String schedulableClassName,String batchableClassName){
      try {
        Type newSchedulerType = Type.forName(schedulableClassName);
              
        String jobID = System.schedule('Schedule Batch Job', cron,
         (Schedulable) JSON.deserialize(JSON.serialize
          (new Map<String, Object>{'batchableClassName' => batchableClassName}), newSchedulerType));
  
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
    
}
