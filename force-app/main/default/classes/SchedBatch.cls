public with sharing class SchedBatch implements Schedulable{
  
  public static String scheduleMe(String cronStr) { 
    return System.schedule('My batch Job', cronStr, new SchedBatch());
}

  public void execute(SchedulableContext ctx) {                                
  ID jobID = Database.executeBatch(new BirthdayBatch(),200); 
 }   
}
