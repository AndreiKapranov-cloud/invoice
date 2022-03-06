import { LightningElement, track, wire,api } from 'lwc';
import getOpportunities  from '@salesforce/apex/AccordionController.getOpportunities';
import fetchAccountsByNum  from '@salesforce/apex/AccordionController.fetchAccountsByNum';
import fetchAccountsByName  from '@salesforce/apex/AccordionController.fetchAccountsByName';
import getListOfProducts  from '@salesforce/apex/OpportunityTableController.getListOfProducts';


const columns = [{
    label: 'Name',
    fieldName: 'Name'
},
{
    label: 'Created Date',
    fieldName: 'CreatedDate',
    type: 'date'
},
{
    label: 'Close Date',
    fieldName: 'CloseDate',
    type: 'date'
},
{
    label: 'Amount',
    fieldName: 'Amount',
},
{
    type: "button",
    fixedWidth: 150,
    typeAttributes: {
        label: 'Sold Products',
        title: 'Sold Products',
        name: 'soldProducts',
        value: 'soldProducts',
        disabled: false,  
        variant: 'brand',
        class: 'scaled-down'
    }
}];
export default class OpportunityTable extends LightningElement {
    @track columns = columns; 
    @api recordId;
    @track error;  
    
    opportunityId = '';
    listOfProducts;
    error;
   
    @track isModalOpen = false;
    @track opportunities;

    @api listOfProducts;

    handleKeyChangeByName( event ) {  
          
        const searchKey = event.target.value;  
  
        if ( searchKey ) {  
  
            fetchAccountsByName( { searchKey } )    
            .then(result => {  
  
                this.accounts = result;  
  
            })  
            .catch(error => {  
  
                this.error = error;  
  
            });  
  
        } else  
        this.accounts = undefined;  
  
    }      
    handleKeyChangeByNumber( event ) {  
          
        const searchKey = event.target.value;  
  
        if ( searchKey ) {  
  
            fetchAccountsByNum( { searchKey } )    
            .then(result => {  
  
                this.accounts = result;  
  
            })  
            .catch(error => {  
  
                this.error = error;  
  
            });  
  
        } else  
        this.accounts = undefined;  
  
    }      

    @wire(getOpportunities, { accountId: '$recordId' })
    wiredOpportunity({ error, data }) {
        if(data) {
            this.opportunities = data;
            this.error = undefined;
        }
        else if(error) {
            this.error = error;
            this.opportunities = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        }
    }
   
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
   
    handleRowAction( event ) {  
          
        this.opportunityId = event.detail.row.Id; 
        const actionName = event.detail.action.name;  
      
      getListOfProducts({ opportunityId: this.opportunityId })
            .then((result) => {
                this.listOfProducts = result;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.contacts = undefined;
            });
    
      if (actionName === 'soldProducts') {
      
            this.isModalOpen = true;
     
        }
    }  
    

}