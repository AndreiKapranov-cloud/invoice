
import { LightningElement, api, wire, track } from 'lwc';
import executeBatchOneTime from '@salesforce/apex/BirthdayBatch.executeBatchOneTime';
import abortBatch from '@salesforce/apex/BirthdayBatch.abortBatch';
import scheduleBatch from '@salesforce/apex/SchedBatch.scheduleBatch';
export default class ScheduleBatch extends LightningElement {
    
    
    @track crron;
    
    batchScheduled = false;
    
    
    executeBatchOneTimeHandler(event) {
 
        executeBatchOneTime();
    }
    handleCronInput(event) {
        if (event.target.name === 'schdlbtch') {   
        this.crron = event.target.value;
     }
    }
    scheduleBatchHandler(event) {
        
        scheduleBatch({cron:this.crron});
        this.batchScheduled = true;
    }
    abortBatchHandler(){
        
        abortBatch();
        this.batchScheduled = false;
    }

}