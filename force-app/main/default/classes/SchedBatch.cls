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
}
