import { LightningElement, api } from 'lwc';
import TESTING_REQUEST from '@salesforce/schema/Testing_Request__c';
import CONFIRMED from '@salesforce/schema/Testing_Request__c.Clinician_Confirmed__c';

export default class ClinicianViewFormDynamicTestRequest extends LightningElement {
    @api recordId;
    @api ObjectAPIName;

    fields = [CONFIRMED];
}