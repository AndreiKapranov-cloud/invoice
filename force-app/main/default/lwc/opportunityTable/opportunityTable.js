import { LightningElement, track, wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
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
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
   
    handleRowAction( event ) {  
          
       // const recId =  event.detail.row.Id; 
        this.opportunityId = event.detail.row.Id; 
        const actionName = event.detail.action.name;  
      // @wire(getListOfProducts, {accountId: recId}) productNames;
      
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
      //  this.listOfProducts = getListOfProducts(recId);
            // write your code to open the modal
            this.isModalOpen = true;
     
     
     
     
     /* this.listOfProducts = getListOfProducts(recId);
      const actionName = event.detail.action.name;  
       if (actionName === 'soldProducts') {
        this.listOfProducts = getListOfProducts(recId);
            // write your code to open the modal
            this.isModalOpen = true;
            
       */
        }
    }  
    

}