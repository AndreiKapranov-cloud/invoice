global with sharing class Crossroad implements Schedulable {
    
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
    global void execute(SchedulableContext ctx ) {}


    
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
