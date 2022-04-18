/* 
* @description Responsible for all Meetup sObject trigger behaviors.
*/
public with sharing class MeetupTriggerHandler {
    public void onBeforeInsert(List<Meetup__c> meetupRecords) {
        generateRegistrationCodes(meetupRecords);
    }
    
    /* 
	* @description Populates the given meetup records with a unique Registration Code.
    * @param meetupRecords The list of meetup records to operate on.
    */
    public void generateRegistrationCodes(List<Meetup__c> meetupRecords) {
        Schema.DescribeFieldResult registrationCodeField = Meetup__c.RegistrationCode__c.getDescribe();
        Integer registrationCodeLength = registrationCodeField.getLength();
        
        // Known limitation, if we exceed 50k records then an async
        // process will be required to ensure uniqueness of codes.
        List<Meetup__c> existingMeetups = [
            SELECT Id, RegistrationCode__c 
            FROM Meetup__c
        	LIMIT 50000];
        
        Set<String> existingCodes = new Set<String>();
        for (Meetup__c meetup : existingMeetups) {
            existingCodes.add(meetup.RegistrationCode__c);
        }

		Set<String> newCodes = new Set<String>();
        Integer assignedCodeCount = 0;
        
        // Ensure that each new meetup gets a unique code.
        while(assignedCodeCount < meetupRecords.size()) {
            String thisCode = StringUtil.generateRandomString(registrationCodeLength);
            if (!existingCodes.contains(thisCode) && !newCodes.contains(thisCode)) {
                meetupRecords[assignedCodeCount].RegistrationCode__c = thisCode;
                newCodes.add(thisCode);
                assignedCodeCount++;
            }
        }
    }

}