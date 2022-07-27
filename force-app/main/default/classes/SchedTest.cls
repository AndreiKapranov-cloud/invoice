@isTest
public class SchedTest {
    @isTest 
    public static void TestBetch() {
    Test.startTest();
    Type newSchedulerType = Type.forName('SchedBatch');
    String batchableClassName = 'BirthdayBatch';
    
    Schedulable  ddd = (Schedulable) JSON.deserialize(JSON.serialize
    (new Map<String, Object>{'batchableClassName' => batchableClassName}), newSchedulerType);
    ddd.execute(null);                   
    Crossroad.abortBatch();
   
    Test.stopTest();
    }
  
  
}