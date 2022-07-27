trigger PayTrigger on Payment__c (after insert) {
   
    Set<ID> ids = Trigger.newMap.keySet();
    List<Payment__c> paymentList = [SELECT Id,Amount__c,Opportunity__r.Id,
      Opportunity__r.PaymentStatus__c,Opportunity__r.PaymentBalance__c,
        Opportunity__r.Amount,Opportunity__r.StageName,Opportunity__r.Tips__c,
         Opportunity__r.OwnerId
           FROM Payment__c WHERE Id IN :ids]; 
      
    List<Id>oppIds = new List<Id>();
    List <Opportunity> oppListWithDuplicates = new List<Opportunity>();    
      
    for(Payment__c payment : paymentList){
      oppIds.add(payment.Opportunity__r.Id);
      oppListWithDuplicates.add(payment.Opportunity__r);
    }
   
    //getting rid of duplicates
    Set<Opportunity> myset = new Set<Opportunity>();
    List<Opportunity> oppList = new List<Opportunity>();
    myset.addAll(oppListWithDuplicates);
    oppList.addAll(myset);   
  
      
    //creating map to avoid for loop inside for loop
    List <OpportunityContactRole> opConRoleList = [SELECT Contact.OwnerId,OpportunityId 
    FROM OpportunityContactRole where OpportunityId IN :oppIds];

    List<Id>OCROppIdList = new List<Id>();
 
    for(OpportunityContactRole ocr : opConRoleList){
        OCROppIdList.add(ocr.OpportunityId);
    }
    Map<Id, OpportunityContactRole> MyMap = new Map<Id, OpportunityContactRole>();
    for (Integer i = 0; i < OCROppIdList.size(); i++) {
    MyMap.put(OCROppIdList[i], opConRoleList[i]);
    }
    
    
    List<Task> tasks = new List<Task>();
    
    Date today = Date.today();    
    DateTime nextDay = today+1;
    DateTime remTime = nextDay.addHours(10);
  
    for(Payment__c payment : paymentList){          
    payment.Opportunity__r.PaymentBalance__c += payment.Amount__c;               
    
     if(payment.Opportunity__r.PaymentBalance__c >= payment.Opportunity__r.Amount){
     payment.Opportunity__r.Tips__c += payment.Opportunity__r.PaymentBalance__c - payment.Opportunity__r.Amount;
               
     payment.Opportunity__r.PaymentBalance__c = payment.Opportunity__r.Amount;
                
     payment.Opportunity__r.PaymentStatus__c = 'Fully Paid'; 
     payment.Opportunity__r.StageName = 'Fully Paid';
             
     Id conOwnerId = MyMap.get(payment.Opportunity__r.Id).Contact.OwnerId;
         
     Task task = new Task(whatID = payment.Opportunity__r.Id,OwnerId = conOwnerId,
     Priority = 'High',Status = 'Not Started',Subject = 'Delivery of Goods',
     Description = 'Fully Paid,can deliver now.',IsReminderSet = true,
     ReminderDateTime = remTime);     
     tasks.add(task);
         
     } else if(payment.Opportunity__r.PaymentBalance__c < payment.Opportunity__r.Amount &&
               payment.Opportunity__r.PaymentBalance__c > 0 ){
                payment.Opportunity__r.PaymentStatus__c = 'Partially Paid';   
                payment.Opportunity__r.StageName = 'Partially Paid';
            }        
        }     
    upsert oppList;
    upsert tasks;   
  }