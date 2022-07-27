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
  @AuraEnabled(cacheable=true)
  global static ID executeBatchOneTime(String batchableClassName){
   try {
    Type newBatchType = Type.forName(batchableClassName);
    ID jobID = Database.executeBatch((Database.Batchable<sObject>)newBatchType.newInstance(),200); 
    system.debug(jobID);
    return jobID;
   } catch (Exception e) {
   throw new AuraHandledException(e.getMessage());
    }
   }
   @AuraEnabled(cacheable=true)
   global static Id getAsyncApexJobId(ID jobId) {
    AsyncApexJob aAJ;
    List<AsyncApexJob> asyncAJ = [
    Select  ID from AsyncApexJob where Status = 'completed' and          
    ID =: jobId LIMIT 1];
     if(asyncAJ.size()>0){
     aAJ = asyncAJ[0];
      }
     system.debug(aAJ);
       
    return aAJ.Id;
    
   }

   @AuraEnabled(cacheable=true)
   global static CronTrigger getCronTrigger() {       
    List<CronTrigger> cronTriggers = [
    SELECT Id, CronExpression
    FROM CronTrigger
    WHERE CronJobDetail.Name = 'Schedule Batch Job'
    LIMIT 1
     ];
     CronTrigger cronTrigger = (cronTriggers.size() == 1)
       ? cronTriggers.get(0)
       : null;       
       return cronTrigger;
      }
   @AuraEnabled(cacheable=true)
   public static string getCronExpression(){
    try {
     CronTrigger ct = getCronTrigger();
    return ct.CronExpression; 
    } catch (Exception e) {
     throw new AuraHandledException(e.getMessage());
    }
   }       
   @AuraEnabled
   global static Boolean abortBatch() {
    try {     
     System.abortJob(getCronTrigger().Id);
     return true;
     } catch (Exception e) {
     System.debug(e.getMessage());
     return false;
       }
   }   
   @AuraEnabled(cacheable=true)
   global static CronTrigger getCronTriggerForAbort() {       
       return getCronTrigger();
      }
}