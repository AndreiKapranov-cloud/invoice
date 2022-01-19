import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getRecipientFName from '@salesforce/apex/EmailHandler.getRecipientFName';
import getRecipientName from '@salesforce/apex/EmailHandler.getRecipientName';
import getInvoiceNumber from '@salesforce/apex/EmailHandler.getInvoiceNumber';
import sendEmail from '@salesforce/apex/EmailHandler.sendEmail';
import getAddress from '@salesforce/apex/EmailHandler.getAddress';
import getEmailTemplate from '@salesforce/apex/EmailHandler.getEmailTemplate';
import getOpportunity from '@salesforce/apex/EmailHandler.getOpportunity';
import getRelatedFilesByRecordId from '@salesforce/apex/EmailHandler.getRelatedFilesByRecordId';
export default class SendEmail extends LightningElement {
  
   @api 
   recordId;
  
   @wire(getInvoiceNumber, {idOpportunity: '$recordId'}) invoiceNumber;
   @wire(getRecipientFName, {idOpportunity: '$recordId'}) recipientFN;
   @wire(getRecipientName, {idOpportunity: '$recordId'}) recipientName;
   @wire(getAddress, {idOpportunity: '$recordId'}) address;
   @wire(getOpportunity,{idOpportunity: '$recordId'}) opp;
   
   @track email = '';
    
   @track error;
   
   @api heightInRem;
    record;
    recip;
    
    showPdf = false;
    // Specify which file for child component to render
    @track fileID;
    pdfFiles = [];

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
        return (this.record?.Body).replace(/{!Contact.FirstName}/g,this.recipientFN.data);                       //JSON.stringify(this.recipient.data));
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
        // send mail
        console.log("Sending email to", this.email);
        sendEmail({ toAddress: this.address.data, subject: this.subject, body: this.body, recordId: this.recordId});
    }
    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        if (data) {
            this.pdfFiles = data;
            this.error = undefined;
            // Save the first related PDF's file ID to fileID            
            const fileIDs = Object.keys(data);
            this.fileID =  fileIDs.length ? fileIDs[0] : undefined; 
        } else if (error) {
            this.error = error;
            this.pdfFiles = undefined; 
            this.fileID = undefined; 
        }
    }
     // Maps file ID and title to tab value and label
     get tabs() {
        if (!this.fileID) return [];

        const tabs = [];
        const files = Object.entries(this.pdfFiles);
        for (const [ID, title] of files) {
            tabs.push({
                value: ID,
                label: title
            });
        }        
        return tabs;
    }

    // event handler for each tab: onclick tab, change fileID
    setFileID(e) {
        this.fileID = e.target.value;
    }
    showPdfHandler(){
      this.showPdf = true;
    }
  
}