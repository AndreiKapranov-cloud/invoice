import { LightningElement, track, wire } from 'lwc';
import retriveAccounts  from '@salesforce/apex/AccordionController.retriveAccounts';
import getOpportunities  from '@salesforce/apex/AccordionController.getOpportunities';
import fetchAccountsByNum  from '@salesforce/apex/AccordionController.fetchAccountsByNum';
import fetchAccountsByName  from '@salesforce/apex/AccordionController.fetchAccountsByName';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class Accordion extends LightningElement {
    @track accounts;
    @track opportunities;
   
    visibleAccounts;

    updateAccountHandler(event){
        this.visibleAccounts=[...event.detail.records]
        console.log(event.detail.records)
    }
    

    @wire(retriveAccounts)
    wiredAccount({ error, data }) {
        if(data) {
            this.accounts = data;
            this.error = undefined;
        }
        else if(error) {
            this.error = error;
            this.accounts = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        }
    }
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
    handleNextPage(event){
        if(this.pageNumber < this.totalPageCount){
            this.pageNumber = this.pageNumber + 1;
        }
        this.handlePageChange();
    }  
    handlePrevpage(event){
        if(this.pageNumber>1){
            this.pageNumber = this.pageNumber-1;
            this.handlePageChange();
        }
    }
    
}
