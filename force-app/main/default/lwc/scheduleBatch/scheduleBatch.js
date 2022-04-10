
import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import executeBatchOneTime from '@salesforce/apex/Crossroad.executeBatchOneTime';
import abortBatch from '@salesforce/apex/Crossroad.abortBatch';
import scheduleBatch from '@salesforce/apex/Crossroad.scheduleBatch';
import getCronExpression from '@salesforce/apex/Crossroad.getCronExpression';
import getCronTrigger from '@salesforce/apex/Crossroad.getCronTrigger';
import getAsyncApexJobId from '@salesforce/apex/Crossroad.getAsyncApexJobId';
import getCronTriggerForAbort from '@salesforce/apex/Crossroad.getCronTriggerForAbort';
export default class ScheduleBatch extends LightningElement {
    @api schedulableClassName;
    @api batchableClassName;
    
    cronTrigger;
   
    
    @track error;
    @track disableBtn = true;
    @track cron;
    
    @track batchScheduled = false;
   
    @wire(getCronExpression)
    getCE({ error, data }) {
        if (data) {
            this.cron = data;
            this.error = undefined; 
            this.batchScheduled = true;
        } else if (error) {
            this.error = error;
            this.cron = undefined; 
        }
    }
   
    @wire(getCronTrigger)
    getCT({ error,data }) {
        if (data) {
            this.cronTrigger = data;
            this.error = undefined;
            let isFirstView = localStorage.getItem('isFirstView') || '';
            if (isFirstView !== 'Yes') {
                /* Show message to use as this is first view. */
                localStorage.setItem('isFirstView', 'Yes');           
                const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Batch Scheduled',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
        }else if (error){
            console.log('Something went wrong:', error);
        }         
    }
    

   executeBatchOneTimeHandler(event) {
       
   executeBatchOneTime({batchableClassName:this.batchableClassName})
   .then((result) =>{   
    let delayInMilliseconds = 2000;

    setTimeout(function() {
        
      if(getAsyncApexJobId({jobId:result})){
           const evt = new ShowToastEvent({
               title: 'Success',
               message: 'Batch Executed',
               variant: 'success',
               mode: 'dismissable'
           });
           this.dispatchEvent(evt);  
       } else {
           const evt = new ShowToastEvent({
               title: 'Error',
               message: 'Batch Not Executed',
               variant: 'error',
               mode: 'dismissable'
           });
           this.dispatchEvent(evt); 
       }  
    }, delayInMilliseconds);
        
    })
        .catch(error => {
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Batch Not Completed',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt); 
        });
 
    }
 
    handleCronInput(event) {
        if (event.target.name === 'schdlbtch') {   
        this.cron = event.target.value;
        if(this.cron == null || this.cron == ''||this.cron.length < 11){
            this.disableBtn = true;
          }else{
            this.disableBtn = false;
          }
       }
    }
    
    scheduleBatchHandler(event) {
             
        scheduleBatch({cron:this.cron,schedulableClassName:this.schedulableClassName,
            batchableClassName:this.batchableClassName})
            .then(result =>{   
                           
            this.batchScheduled = true;
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Batch Not Scheduled',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.batchScheduled = false;
                this.disableBtn = true;   
            });
            localStorage.setItem('isFirstView', 'No');
      getCT();          
        }        
    
    abortBatchHandler(){
        
       abortBatch();
       this.batchScheduled = false;
       this.disableBtn = true;
        let delayInMillisecond = 2000;

        setTimeout(function() {
            
         getCronTriggerForAbort()
            .then(result => {
               if(result){
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Batch Not Aborted',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt); 
            }else{           
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Batch Aborted',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);            
                  }              
            })
            .catch(error => {
                this.error = error;
            }); 
           
        }, delayInMillisecond);                
    }
}