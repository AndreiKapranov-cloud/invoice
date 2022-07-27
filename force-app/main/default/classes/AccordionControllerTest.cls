@isTest
public class AccordionControllerTest {
@isTest
    static void getAccountList() {
       
       List<Account>ac = testDataFactory.createAccounts();
       

        Test.startTest();
        List<Account> accts = AccordionController.retriveAccounts();
        System.assertEquals(10, accts.size());
        Test.stopTest();

        System.assertEquals(accts.size(), 10);
    }
    @isTest
    static void getOpportunityList() {
        Account acc = new Account(Name = 'Name');
        insert acc;
       List<Opportunity> opp = testDataFactory.createOpportunitiesClosedWon();
        for(Opportunity o : opp){
            o.AccountId = acc.Id;
         }
        
        upsert opp;
           
         Test.startTest();
       List<Opportunity>newOpList = AccordionController.getOpportunities(acc.Id);
        Test.stopTest();
        System.assertEquals(newOpList.size(), 10);
        System.assertEquals(newOpList[0].AccountId, acc.Id);
    }
   
    
    @isTest static void fetchAccountsByNameTest(){
      Opportunity opp = TestDataFactory.createOpportunity();
        opp.stageName = 'Closed Won';
        upsert opp;
        
        Contact con = TestDataFactory.createContact();  
        
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        opp.AccountId = acc.Id;
        
        con.AccountId = acc.Id;
        
        List<Account>ac = testDataFactory.createAccounts();
        for(Integer i = 0;i< ac.size()+1; i++){
            for(Account a :ac){
                a.name = 'name' + i;
               
            }
        }
        List<Account> accountTest = AccordionController.fetchAccountsByName('name');
        List<Account> accountTest1 = AccordionController.fetchAccountsByNum('1');
        System.assertEquals(10, accountTest.size());
        System.assertEquals(10, accountTest1.size());
    }
}