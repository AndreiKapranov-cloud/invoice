global with sharing class Crossroad implements Schedulable {
    
    @AuraEnabled
    global static void scheduleBatch(String cron,String schedulableClassName){
      try {
        Type newSchedulerType = Type.forName(schedulableClassName);
        String jobID = System.schedule('Schedule Batch Job', cron, (Schedulable)newSchedulerType.newInstance());
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
