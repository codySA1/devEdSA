@isTest
private with sharing class MeetupRegistrationServiceTest {
    
    @isTest
    private static void isEmailRegistered_existingRegistration_expectTrue(){
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

        insert testMeetupRegistration;

        Boolean isEmailRegistered = MeetupRegistrationService.isEmailRegistered(testMeetupRegistration.Email__c, testMeetup.Id);
        System.assert(isEmailRegistered, 'Expected true as we have already inserted a registration for this email and meetup.');
    }

    @isTest
    private static void isEmailRegistered_noExistingRegistration_expectFalse(){
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

        insert testMeetupRegistration;

        Boolean isEmailRegistered = MeetupRegistrationService.isEmailRegistered('other@example.com', testMeetup.Id);
        System.assert(!isEmailRegistered, 'Expected false as no registration has been created for this email yet.');
    }
}
