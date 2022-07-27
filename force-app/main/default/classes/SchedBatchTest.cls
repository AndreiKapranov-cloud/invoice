@isTest
public class SchedBatchTest {

    @isTest
    public static void scheduleTest() {
    Id jobId;
    List<Contact>conList = new List<Contact>();
    
    Contact con = new Contact(
        FirstName='Jjjdcad',
        LastName='kkadcadc',
        Birthdate= date.today(),
        Phone='888909879866',
        Email = 'hvhmcg@tut.by'
        );
    conList.add(con);
    insert conList;
    
    Test.startTest();
    Crossroad.scheduleBatch('0 0 0 * * ?','SchedBatch','BirthdayBatch');
      
    Crossroad.executeBatchOneTime('BirthdayBatch'); 
  
    Crossroad.getCronExpression();
    Crossroad.abortBatch();
    Crossroad.getCronTriggerForAbort();
    SchedBatch scbtch = new SchedBatch();
    
    scbtch.start(null);
    scbtch.execute(null, conList);
    scbtch.finish(null);
     
       
    Crossroad crossroads = new Crossroad();
    crossroads.execute(null);
    
    Test.stopTest();   
  }
     @isTest(SeeAllData=true)
     static void testGetJobId(){
          AsyncApexJob aAJ;
        List<AsyncApexJob> asyncAJ = [ 
          Select  ID
          from AsyncApexJob where Status = 'completed' 
          LIMIT 1
          ];
          if(asyncAJ.size()>0){
          aAJ = asyncAJ[0];
          }
    Crossroad.getAsyncApexJobId(aAJ.Id);
            }
}