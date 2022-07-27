@isTest
public class CreatePaymentTest {
   
 @isTest(SeeAllData=true) 
    static void testCreatePayment() {
    Opportunity opp = TestDataFactory.createOpportunity();
   
    String jsonBody = '[{"Opportunity": "0065j000002P7XlAAK","Amount": 200,"FirstName": "Andrei","LastName": "Kapranov"}, {"Opportunity": "0065j000002P7XlAAK","Amount": 200, "FirstName": "Andrei","LastName": "Kapranov"} ]';
    List<CreatePayment.PaymentWrapper>payments = (List<CreatePayment.PaymentWrapper>)JSON.deserialize(jsonBody,List<CreatePayment.PaymentWrapper>.class);
     
    List<ID>ideaList = CreatePayment.doPost(payments);
 }}