@isTest
public class PayTrigTest {
   @isTest 
    public static void TestInsertPayment() {  
    Opportunity opp = new Opportunity(Name = 'Paym', StageName ='Prospecting' , CloseDate = date.today().addMonths(2), PaymentBalance__c = 0,PaymentStatus__c = 'Not Paid',Amount = 360);
    Contact con = new Contact(FirstName = 'John',LastName = 'Quick');
    insert opp;
    insert con;
   
    OpportunityContactRole ocp = new OpportunityContactRole(OpportunityId = opp.Id,ContactId = con.Id);     
    insert ocp;        
     Payment__c payment = new Payment__c( FirstName__c = 'Andy', LastName__c = 'Kap',Amount__c = 10,Opportunity__c = opp.Id);
     Payment__c payment1 = new Payment__c( FirstName__c = 'Andy', LastName__c = 'Kap',Amount__c = 300,Opportunity__c = opp.Id);
     Payment__c payment2 = new Payment__c( FirstName__c = 'Andy', LastName__c = 'Kap',Amount__c = 360,Opportunity__c = opp.Id); 
     Test.startTest();
      insert payment;
      insert payment1;
        
     Test.stopTest();
    
   }
}