import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Program_Project__c.Id';
import FIT_CVO_bool from '@salesforce/schema/Program_Project__c.Critical_Value_FIT__c';
import A1C_CVO_bool from '@salesforce/schema/Program_Project__c.Critical_Value_A1c__c';
import A1C_CVO_Value from '@salesforce/schema/Program_Project__c.Critical_Value_A1c_Threshold__c';
import A1C_CVO_Op from '@salesforce/schema/Program_Project__c.CVO_Operator_A1c__c';

export default class EditCVOScreenAction extends LightningElement {
    @api recordId;
    @api objectApiName;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [FIT_CVO_bool, A1C_CVO_bool, A1C_CVO_Value, A1C_CVO_Op]
    })
    pp;

    get fitbool(){
        return this.pp.data
        ? this.pp.data.fields.Critical_Value_FIT__c
        : null;
    }

    get a1cbool(){
        return this.pp.data
        ? this.pp.data.fields.Critical_Value_A1c__c
        : null;
    }

    handleSave(){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated',
                    variant: 'success'
                })
            );

            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record, try again...',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}