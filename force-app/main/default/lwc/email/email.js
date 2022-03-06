import { LightningElement, api, wire, track } from 'lwc';
import getInvoiceFileId from '@salesforce/apex/EmailHandler.getInvoiceFileId';
import getRecipientFName from '@salesforce/apex/EmailHandler.getRecipientFName';
import getRecipientName from '@salesforce/apex/EmailHandler.getRecipientName';
import getInvoiceNumber from '@salesforce/apex/EmailHandler.getInvoiceNumber';
import sendEmail from '@salesforce/apex/EmailHandler.sendEmail';
import getAddress from '@salesforce/apex/EmailHandler.getAddress';
import getEmailTemplate from '@salesforce/apex/EmailHandler.getEmailTemplate';
import getOpportunity from '@salesforce/apex/EmailHandler.getOpportunity';

export default class SendEmail extends LightningElement {
  
   @api 
   recordId;
   
   @track email = '';
    
   @track error;
   
   @api heightInRem;
  
   @track fileID;

   record;
    
   showPdf = false;

   
   @wire(getInvoiceNumber, {idOpportunity: '$recordId'}) invoiceNumber;
   @wire(getRecipientFName, {idOpportunity: '$recordId'}) recipientFN;
   @wire(getRecipientName, {idOpportunity: '$recordId'}) recipientName;
   @wire(getAddress, {idOpportunity: '$recordId'}) address;
   @wire(getOpportunity,{idOpportunity: '$recordId'}) opp;
   
   @wire(getEmailTemplate)
    wiredTemplate({ error, data }) {
        if (data) {
            this.record = data;
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }
   

    get mySubject() {
        return (this.record?.Subject).replace(/{!Opportunity.Invoice_number__c}/g,this.invoiceNumber.data);  
    }                                                                                         
    
    get myBody() {
        return (this.record?.Body).replace(/{!Contact.FirstName}/g,this.recipientFN.data);                       
    }
  
    handleChangeEmail(event) {
        if (event.target.name === 'emailAddress') {
            this.email = event.target.value;
        }
    }
  
    handleChangeSubject(event) {
        if (target.name === 'emailSubject') {
            this.subject = event.target.value;

        }
    }
    
    handleChangeBody(event) {
        if (event.target.name === 'emailBody') {
            this.body = event.target.value;
        }
    }

    sendEmailHandler(event) {
        console.log("Sending email to", this.email);
        sendEmail({ toAddress: this.address.data, subject: this.subject, body: this.body, recordId: this.recordId});
    }
  
    @wire(getInvoiceFileId, { recordId: '$recordId' })
    wiredFileID({ error, data }) {
        if (data) {
            this.fileID = data;
            this.error = undefined;   
        } else if (error) {
            this.error = error;
            this.fileID = undefined; 
        }
    }

    showPdfHandler(){
      this.showPdf = true;
    }
  
}