 The project consists of two tasks:
 First task:
 1.Create visualforce page that will generate a PDF page with data based on Opportunity.
The header contains info about our company from settings of our organization.
In the 'Bill To' section the info about the client must be displayed.The info comes from Opportunity Contact Role 
record with isPrimary = true.
Table with products has to be filled using records of Opportunity Product and contain the total sum of the bill.
The footer has to display the name of our company.
Implement pagination.Header and footer automaticaly move to the next pages.
Size of the document is A4.
 2.Create a quick Action on Opportunity object record.Name-'Generate Invoice'.Quick Action should generate a bill 
for Opportunity and attach it to the Opportunity record as a PDF file.Get the name of the file from the 'Invoice 
number' field,that you should on the Opportunity object,type 'Auto Number',format 'INV-000000'.If a file with the same name 
already exists - you should create its new version creating a record of ContentVersion object for existing 
ContentDocument.
 3.Create an Email Template.Figure out the text of the letter to the client.
 4.Create an LWC component that will open when click on the Quick Action named 'Send Invoice' on the Opportunity object
 record(have to create this Quick Action).
    The component should display precompleted email subject(from our Email Template).The field is readonly.
    The field should contain the invoice number,same as in the file that was generated before,the same format
    INV-000000.
    The component should display precompleted email boby (from our Email Template).The field should be editable.
    The component should display precompleted recipient name(should get it from Opportunity Contact Role object
    record with isPrimary = true).Field read only.
    The component should display precompleted recipient email(should get it from Opportunity Contact Role object
    record with isPrimary = true).Readonly.
    Create a button for preview of the bill that was generated by the 'Generate Invoice' quick action.
    Create a 'Send' button for sending the email.
    
    
    
  We recieved a confirmation letter.The component should find Opportunity by the Invoice number.If the Opportunity
  is still waiting for confirmation - should parse the email response and change status of the Opportunity.If response 
  is 'Approved' - then move to next status,if Rejected - move to status 'Close Lost'.
  
  
  
  Create new LWC component which we could place on a distinct tab in our org,or at an Account detail page.
  If distinct tab,then the component should contain:-lightning-accordion,account name and total sum of all 
  closed opportunities should be displayed on each block header button.The body of the block contains table
  with info about opportunity:Opportunity name(link to opportunity);Created date;Close date;Amount;a button that 
  opens a modal window with a list of sold products(Opportunity Product).There must be search by Name of Account
  and by total sum of all Opportunities in each Account.Pagination-10 accounts on a page.If component is placed on an 
  account page:depict info only about this account,hide pagination and search.
  
  
  
  Second task:
  Create a Rest Web Service that would help a bank send us data about the payment of invoices.
  First create the data model.Create an object Payment containing nexxt fields:
  1.Name(Auto Number)-standart field.
  2.Opportunity(Master Detail)-link to the Opportunity record.
  3.Amount(Number 16,2)-info about the sum of paiment.
  4.FirstName.
  5.LastName.
  Rest Web Service:1.Access to Web Service - OAuth Technology.
  2.POST HTTP method.
  3.JSON structure:
  {
   "payments":[
    {
     "Opportunity":{String},
     "Amount":{Decimal},
     "FirstName":{String},
     "LastName":{String}
     }
    ]
   }
   4.When sending a request to our Web Service new Payment Object records would be created.
   
   Trigger.
   When invoice payment recieved the status of the Opportunity records should change:"Partially paid" or
   "Fully paid".When fully paid-need to create a Task for the user,responsible for the Opportunity,to remind him to 
   send the goods.
    Create a trigger on the Payment object.The trigger has to sum the total payment balance for each Opportunity record
    based on the records of the Payment records.If partially paid-move the Opportunity to "Partially Paid" status.
    If fully paid-move to "Fully Paid" status and create a Task for the user on sending the goods.
    
    
    Batch,Scheduler.
    Should process all Contact records every day.And if it's client's birth day,should send him a letter with congratulations.
    Create an Email Template.Implement a Batch class,implement a schedule for everyday implementing of the logic.
    
    Create an LWC component to manage our sending companies.We need to manage our schedulers directly from the user's interface.
    The component should allow us:1.Launch the concrete batch one time.2.Launch the scheduler.3.Abort the scheduler.
    
    The component shouldn't work with specific class,but accept the name of the Batch and the name of the Scheduler 
    as parameters.We should provide a generic component,that can be reused.
  
    



