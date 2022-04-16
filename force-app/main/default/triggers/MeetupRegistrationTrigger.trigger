trigger MeetupRegistrationTrigger on MeetupRegistration__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        new MeetupRegistrationTriggerHandler().onBeforeInsert(Trigger.new);
    }
}