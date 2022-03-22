global with sharing class SchedBatch implements Schedulable{
  
 
  @AuraEnabled
  public static void scheduleBatch(String cron){
    try {
      String jobID = System.schedule('Schedule Batch Job', cron, new SchedBatch());
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  
   global void execute(SchedulableContext ctx ) {
   BirthdayBatch bb = new BirthdayBatch();
   Database.executeBatch(bb,200);
 }
/*
 global void executeBatch(SchedulableContext ctx,String batchableClassName){
 Type newBatchType = Type.forName('batchableClassName');
 Database.executeBatch((Batchable)newBatchType.newInstance(),200);
 }

 global void execute(SchedulableContext ctx ) {
 // Type newBatchType = Type.forName('batchableClassName');
 // Database.executeBatch((Batchable)newBatchType.newInstance(),200);
 }
*/
}
