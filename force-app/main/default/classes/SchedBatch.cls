global with sharing class SchedBatch implements Schedulable,Database.Batchable<sObject>{
  
  public String batchableClassName = '';
  public SchedBatch(){
  }
  /*@AuraEnabled
  public static void scheduleBatch(String cron){
    try {
      String jobID = System.schedule('Schedule Batch Job', cron, new SchedBatch());
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }*/
  
   
   global void execute(SchedulableContext ctx) {
    Type newBatchType = Type.forName(batchableClassName);
    Database.executeBatch((Database.Batchable<sObject>)newBatchType.newInstance(),200);
  }
  
  
  
  
  //global void execute(SchedulableContext ctx) {
   
  // BirthdayBatch bb = new BirthdayBatch();
  // Database.executeBatch(bb,200);
// }
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
global database.querylocator start(Database.BatchableContext BC)
    {return Database.getQueryLocator(
      'SELECT Id,FirstName,Email,Birthdate FROM Contact'
  );}
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    { }
    global void finish(Database.BatchableContext BC){

    }
}
