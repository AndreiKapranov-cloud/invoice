@RestResource(urlMapping='/payments/*')
global class CreatePayment {
   global class PaymentWrapper {
		public Id opportunity;
		public Decimal amount;
		public String firstName;
		public String lastname;
     public Payment__c getPayment() {
     return new Payment__c(
				Opportunity__c = this.opportunity,
				Amount__c = this.amount,
				FirstName__c = this.firstName,
				LastName__c =this.lastname
			);
		}
	}  
    @HttpPost
    global static List<ID> doPost(List<PaymentWrapper>payments) {
       List<Payment__c> paymentsToInsert = new List<Payment__c>();

		for (PaymentWrapper payment : payments) {
			paymentsToInsert.add(payment.getPayment());
		}

		insert paymentsToInsert;

		Map<Id, Payment__c> paymentMap = new Map<Id, Payment__c>(paymentsToInsert);
		return new List<Id>(paymentMap.keySet());
	}
        
}