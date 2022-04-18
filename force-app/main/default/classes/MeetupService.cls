/* 
* @description Handles operations related to Meetups.
*/
public with sharing class MeetupService {
    
    /* 
	* @description Returns a meetup that can be registered for (it exists, is open, and has capacity).
    * @param registrationCode The unique registration code of the meetup to evaluate.
    * @return Meetup__c the meetup if it's registerable, otherwise null.
    */
    @AuraEnabled(cacheable=true)
    public static Meetup__c getRegisterableMeetup(String registrationCode) {
        List<Meetup__c> openMeetups = [
            SELECT Id, Name, RegistrationLimit__c,
                (SELECT Id FROM MeetupRegistrations__r)
            FROM Meetup__c
            WHERE RegistrationCode__c = :registrationCode
            AND Status__c = 'Open'
            LIMIT 1
        ];

        if (openMeetups.isEmpty()) {
            return null;
        }

        Meetup__c openMeetup = openMeetups[0];
        if (openMeetup.RegistrationLimit__c <= openMeetup.MeetupRegistrations__r.size()) {
            return null;
        }

        // Limit data returned to client.
        return new Meetup__c(Id = openMeetup.Id, Name = openMeetup.Name);
    }
}
