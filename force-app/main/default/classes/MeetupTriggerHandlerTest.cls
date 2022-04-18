@isTest
private with sharing class MeetupTriggerHandlerTest {

    @isTest
    private static void onBeforeInsert_expectRegistrationCodeGenerated() {
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Unit Test Meetup',
            Status__c = 'Open',
            RegistrationLimit__c = 1
        );

        insert testMeetup;

        testMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Id = :testMeetup.Id];

        System.assertNotEquals(null, testMeetup.RegistrationCode__c, 
            'Expected a registration code to be generated for the meetup when inserted.');
    }
}
