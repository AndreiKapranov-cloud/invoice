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
  
}
