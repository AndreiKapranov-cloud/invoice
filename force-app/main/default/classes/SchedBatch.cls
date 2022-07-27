global with sharing class SchedBatch implements Schedulable,Database.Batchable<sObject>{
  
  public String batchableClassName = '';
  public SchedBatch(){
  }
  
   global void execute(SchedulableContext ctx) {
    Type newBatchType = Type.forName(batchableClassName);
    Database.executeBatch((Database.Batchable<sObject>)newBatchType.newInstance(),200);
  }
  
  
  
  
  global database.querylocator start(Database.BatchableContext BC)
    {return Database.getQueryLocator(
      'SELECT Id,FirstName,Email,Birthdate FROM Contact'
  );}
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    { }
    global void finish(Database.BatchableContext BC){

    }
}