/* 
* @description Handles operations related to Meetup Registrations.
*/
public with sharing class MeetupRegistrationService {
    
    /* 
	* @description Determines if an existing registration has been made for the given email and meetup.
    * @param emailAddress The registrant email to match on.
    * @param meetupId The meetup to match on.
    */
    @AuraEnabled(cacheable=true)
    public static Boolean isEmailRegistered(String emailAddress, Id meetupId) {
        List<MeetupRegistration__c> existingRegistrations = [
            SELECT Id 
            FROM MeetupRegistration__c
            WHERE Meetup__c = :meetupId
            AND Email__c = :emailAddress
            LIMIT 1
        ];

        return existingRegistrations.size() > 0;
    }
}
