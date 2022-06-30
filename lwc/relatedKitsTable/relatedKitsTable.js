import { LightningElement, wire, track } from 'lwc';

//import method from the Apex Class
import getContactKits from '@salesforce/apex/ParticipantKitQuickController.getContactKits';

const columns = [{
    label: 'View',
    type: 'button-icon',
    initialWidth: 75,
    typeAttributes: {
        iconName: 'action:preview',
        title: 'Preview',
        variant: 'border-filled',
        alternativeText: 'View'
    }
},
{
    label: 'Locator ID',
    fieldName: 'Name'
},
{
    label: 'Status',
    fieldName: 'Status__c'
},
{
    label: 'Entered By',
    fieldName: 'Entered_By__c'
},
{
    label: 'Order Date',
    fieldName: 'Date_Ordered__c'
},
{
    label: 'Result Date',
    fieldName: 'Date_Resulted__c'
}
];

export default class RelatedKitsTable extends LightningElement {
    @track columns = columns;
    @track record = {};
    @track rowOffset = 0;
    @track data = {};
    @track bShowModal = false;
    @wire(getContactKits) parameters;
 
    // Row Action event to show the details of the record
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }
}