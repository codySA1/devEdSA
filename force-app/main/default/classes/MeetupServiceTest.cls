@isTest
private with sharing class MeetupServiceTest {

    @isTest
    private static void getRegisterableMeetup_validMeetup_expectReturned(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Open',
            RegistrationLimit__c = 10
        );

        insert testMeetup;

        testMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Id = :testMeetup.Id];

        Meetup__c registerableMeetup = MeetupService.getRegisterableMeetup(testMeetup.RegistrationCode__c);
        System.assertEquals(testMeetup.Id, registerableMeetup.Id, 
            'Expected meetup matching the registration code is returned, because it\'s open and has capacity.');
    }

    @isTest
    private static void getRegisterableMeetup_closedMeetup_expectNoneReturned(){
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Closed',
            RegistrationLimit__c = 10
        );

        insert testMeetup;

        testMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Id = :testMeetup.Id];

        Meetup__c registerableMeetup = MeetupService.getRegisterableMeetup(testMeetup.RegistrationCode__c);
        System.assertEquals(null, registerableMeetup, 'Expected the meetup to not be returned as it is closed.');
    }

    @isTest
    private static void getRegisterableMeetup_limitReached_expectNoneReturned(){
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

        testMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Id = :testMeetup.Id];

        Meetup__c registerableMeetup = MeetupService.getRegisterableMeetup(testMeetup.RegistrationCode__c);
        System.assertEquals(null, registerableMeetup, 'Expected the meetup to not be returned as the limit is reached.');
    }
}
