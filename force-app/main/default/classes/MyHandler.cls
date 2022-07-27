global class MyHandler implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          String myPlainText= '';  
          String subject = '';
          
          myPlainText = email.plainTextBody;
         
          subject = email.subject; 
        
          try{
           
          Pattern pInv = Pattern.compile('(?i)INV-\\d\\d\\d\\d\\d\\d');
          Matcher pm = pInv.matcher(subject);
          //String tratata = pm.group(0); присваиваю переменной-получаю Line: 38, Column: 1
                                        //System.StringException: No match found

              
              
          Pattern pAppr = Pattern.compile('(?i)Approved');
          Matcher apprMatcher = pAppr.matcher(myPlainText);
          Pattern pRej = Pattern.compile('(?i)Rejected');
          Matcher rejMatcher = pRej.matcher(myPlainText);
         
          boolean isRejected = rejMatcher.find();
          boolean isApproved = apprMatcher.find();//если без переменной напрямую-
                                                 //то не распознаёт true,не работает
          
          System.debug(pm.find()); //без этой строчки не работает....чертовщина
          System.debug(isApproved);
          System.debug(isRejected);
              
          Opportunity opp = [select Id,StageName from Opportunity where Invoice_number__c =: pm.group(0)];
              
            if(isApproved) {
                  switch on opp.StageName { 
            when 'Prospecting' {	
                opp.StageName ='Qualification';
            } 
            when 'Qualification' {		
                opp.StageName ='Needs Analysis';
            }
            when 'Needs Analysis' {		
                opp.StageName ='Value Proposition';
            }          
            when 'Value Proposition' {		
                opp.StageName ='Id. Decision Makers';
            }          
            when 'Id. Decision Makers' {		
                opp.StageName ='Perception Analysis';
            }          
            when 'Perception Analysis' {		
                opp.StageName ='Proposal/Price Quote';
            }                     
            when 'Proposal/Price Quote' {		
                opp.StageName ='Negotiation/Review';
            }    
            when 'Negotiation/Review' {		
                opp.StageName ='Closed Won';
             } 
            }          
           }
           else if(isRejected){
                   opp.StageName = 'Closed Lost';
            }
               
              
            upsert opp;
            } catch (QueryException e) {
          System.debug('Query Issue: ' + e);
        }
           result.success = true;
               
           return result;
        }
  }