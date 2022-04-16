import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import isEmailRegistered from '@salesforce/apex/MeetupRegistrationService.isEmailRegistered';
import getRegisterableMeetup from '@salesforce/apex/MeetupService.getRegisterableMeetup';

export default class RegistrationForm extends LightningElement {
    validMeetup = true;
    registrationAllowed = true;
    showForm = false;
    meetupName;
    meetupId;

    connectedCallback() {
        // Prepare the initial state of the page, lookup up the meetup and validating it's registerability.
        const urlParamCode = new URLSearchParams(window.location.search).get('c__code');
        if (!urlParamCode) {
            this.validMeetup = false;
            return;
        }
        
        let methodParams = {registrationCode: urlParamCode};
        getRegisterableMeetup(methodParams).then(result => {
            if(result) {
                this.meetupName = result.Name;
                this.meetupId = result.Id;

                this.showForm = true;
            } else {
                this.registrationAllowed = false;
                return;
            }
        })
        .catch(error => {
            this.registrationAllowed = false;
            console.error(error);
        });
    }

    handleSubmit(event){
        // Validate the registration before submitting, providing toast alerts for feedback.
        event.preventDefault();
        let emailValue = event.detail.fields.Email__c;
        let meetupValue = event.detail.fields.Meetup__c;
        let methodParams = {emailAddress: emailValue, meetupId: meetupValue};

        isEmailRegistered(methodParams)
            .then(result => {
                if(result) {
                    const toastEvt = new ShowToastEvent({
                        title: 'Already Registered',
                        message: 'This email is already registered for this event.',
                        variant: 'warning',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(toastEvt);
                } else {
                    // Submission may incur DML, refresh cache so a subsequent call requeries.
                    refreshApex(methodParams);
                    this.template.querySelector('lightning-record-edit-form').submit();
                }
            })
            .catch(error => {
                console.error(error);
                const toastEvt = new ShowToastEvent({
                    title: 'Unexpected Error',
                    message: 'An unexpected error has occured, please contact staff.',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEvt);
            });
     }
    
    handleSuccess(event) {
        const toastEvt = new ShowToastEvent({
            title: 'Registration Successful',
            message: 'We\'ve received your request, thank you!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(toastEvt);
    }

    handleError(event) {
        const toastEvt = new ShowToastEvent({
            title: 'Registration Unsuccessful',
            message: JSON.stringify(event.detail.detail),
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(toastEvt);
    }
}