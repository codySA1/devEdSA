trigger MeetupTrigger on Meetup__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        new MeetupTriggerHandler().onBeforeInsert(Trigger.new);
    }
}