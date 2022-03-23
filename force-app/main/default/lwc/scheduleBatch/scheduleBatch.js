
import { LightningElement, api, wire, track } from 'lwc';
import executeBatchOneTime from '@salesforce/apex/Crossroad.executeBatchOneTime';
import abortBatch from '@salesforce/apex/Crossroad.abortBatch';
import scheduleBatch from '@salesforce/apex/Crossroad.scheduleBatch';
export default class ScheduleBatch extends LightningElement {
    @api schedulableClassName;
    @api batchableClassName;
     
    @track cron;
    @track disableBtn = true;

    batchScheduled = false;
    
    
    executeBatchOneTimeHandler(event) {
 
        executeBatchOneTime({batchableClassName:this.batchableClassName});
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
            batchableClassName:this.batchableClassName});
        this.batchScheduled = true;
    }
    abortBatchHandler(){
        
        abortBatch();
        this.batchScheduled = false;
        this.disableBtn = true;
    }

}