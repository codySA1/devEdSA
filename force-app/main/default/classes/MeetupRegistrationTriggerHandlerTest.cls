@isTest
private with sharing class MeetupRegistrationTriggerHandlerTest {

    @isTest
    private static void onBeforeInsert_validRegistration_expectInserted(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Open',
            RegistrationLimit__c = 1
        );

        insert testMeetup;

        MeetupRegistration__c testMeetupRegistration = new MeetupRegistration__c(
            Meetup__c = testMeetup.Id,
            FirstName__c = 'First',
            LastName__c = 'Last',
            Email__c = 'flast@example.com'
        );

        Database.SaveResult result = Database.insert(testMeetupRegistration);
        System.assert(result.isSuccess(), 'Expected the valid registration to be inserted.');
    }

    @isTest
    private static void onBeforeInsert_meetingIsClosed_expectNotInserted(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Closed',
            RegistrationLimit__c = 1
        );

        insert testMeetup;

        MeetupRegistration__c testMeetupRegistration = new MeetupRegistration__c(
            Meetup__c = testMeetup.Id,
            FirstName__c = 'First',
            LastName__c = 'Last',
            Email__c = 'flast@example.com'
        );

        Database.SaveResult result = Database.insert(testMeetupRegistration, false);
        System.assert(!result.isSuccess(), 'Expected the registration insert to fail due to meetup status.');
    }

    @isTest
    private static void onBeforeInsert_meetingAtCapacity_expectNotInserted(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Open',
            RegistrationLimit__c = 0
        );

        insert testMeetup;

        MeetupRegistration__c testMeetupRegistration = new MeetupRegistration__c(
            Meetup__c = testMeetup.Id,
            FirstName__c = 'First',
            LastName__c = 'Last',
            Email__c = 'flast@example.com'
        );

        Database.SaveResult result = Database.insert(testMeetupRegistration, false);
        System.assert(!result.isSuccess(), 'Expected the registration insert to fail due to meetup capacity.');
    }

    @isTest
    private static void onBeforeInsert_duplicateEmails_expectNotInserted(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Open',
            RegistrationLimit__c = 5
        );

        insert testMeetup;

        MeetupRegistration__c testMeetupRegistration = new MeetupRegistration__c(
            Meetup__c = testMeetup.Id,
            FirstName__c = 'First',
            LastName__c = 'Last',
            Email__c = 'flast@example.com'
        );

        insert testMeetupRegistration;

        MeetupRegistration__c testMeetupRegistration2 = new MeetupRegistration__c(
            Meetup__c = testMeetup.Id,
            FirstName__c = 'First',
            LastName__c = 'Last',
            Email__c = 'flast@example.com'
        );

        Database.SaveResult result = Database.insert(testMeetupRegistration2, false);
        System.assert(!result.isSuccess(), 'Expected the registration insert to fail due to duplicate emails.');
    }
}
