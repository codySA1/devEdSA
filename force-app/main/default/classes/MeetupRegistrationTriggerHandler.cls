/* 
* @description Responsible for all Meetup Registration sObject trigger behaviors.
*/
public with sharing class MeetupRegistrationTriggerHandler {
    public void onBeforeInsert(List<MeetupRegistration__c> meetupRegistrationRecords) {
        validateRegistrations(meetupRegistrationRecords);
    }

    public void validateRegistrations(List<MeetupRegistration__c> meetupRegistrationRecords){
        Map<Id, List<MeetupRegistration__c>> registrationsByMeetupId = new Map<Id, List<MeetupRegistration__c>>();
        for (MeetupRegistration__c registration : meetupRegistrationRecords) {
            if (registrationsByMeetupId.containsKey(registration.Meetup__c)) {
                registrationsByMeetupId.get(registration.Meetup__c).add(registration);
            } else {
                registrationsByMeetupId.put(registration.Meetup__c, new List<MeetupRegistration__c> { registration });
            }
        }

        List<Meetup__c> relatedMeetups = [
            SELECT Id, Name, RegistrationLimit__c, Status__c,
                (SELECT Id, Email__c 
                FROM MeetupRegistrations__r)
            FROM Meetup__c
            WHERE Id IN :registrationsByMeetupId.keySet()
        ];

        for (Meetup__c meetup : relatedMeetups) {
            Integer remainingCapacity = Integer.valueOf(meetup.RegistrationLimit__c) - meetup.MeetupRegistrations__r.size();
            List<MeetupRegistration__c> relatedRegs = registrationsByMeetupId.get(meetup.Id);

            Set<String> existingEmails = new Set<String>();
            for (MeetupRegistration__c existingReg : meetup.MeetupRegistrations__r) {
                existingEmails.add(existingReg.Email__c);
            }
            
            for (MeetupRegistration__c relatedReg : relatedRegs) {
                if (meetup.Status__c == 'Closed') {
                    relatedReg.addError('Registrations cannot be made for meetup '  + meetup.Name + ' because it is closed.');
                    continue;
                }

                if (remainingCapacity <= 0) {
                    relatedReg.addError('Registrations cannot be made for the meetup ' + meetup.Name + ' at maximum capacity.');
                    continue;
                }

                if (existingEmails.contains(relatedReg.Email__c)) {
                    relatedReg.addError('An existing registration for meetup ' + meetup.Name + ' with email ' + relatedReg.Email__c + ' already exists.');
                    continue;
                }

                // Keep track in case we hit capacity mid-loop or duplicate emails were inserted in the same transaction.
                existingEmails.add(relatedReg.Email__c);
                remainingCapacity--;
            }
        }
    }

}
