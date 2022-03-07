import { LightningElement,api} from 'lwc';

import generatePdf from '@salesforce/apex/CreatePdfController.generatePdf';
export default class InvoicePdf extends LightningElement {
    @api 
    recordId;
    
    @api invoke() {
        generatePdf({idOpportunity: this.recordId})
        .then(result => {
            
            this.objDocumentLink.Id = result;
          
            })
         .catch(error => {
            this.error = error;
        });
       
   }
   constructor() {
    super();

    document.addEventListener("lwc://refreshView", () => {
        const evt = new ShowToastEvent({
            title: "Info",
            message: "received refreshView event",
            variant: "info",
        });
        this.dispatchEvent(evt);
    });
  }

   refreshViews() {
    document.dispatchEvent(new CustomEvent("aura://refreshView"));
  }
}
