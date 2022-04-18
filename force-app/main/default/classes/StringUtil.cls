/* 
* @description Utility class for string manipulation and generation methods.
*/
public with sharing class StringUtil {

    /* 
	* @description Generates a random alphanumeric string of given length. Reference: 
	* https://salesforce.stackexchange.com/questions/43823/how-do-i-generate-a-random-string
	*
    * @param len The desired length of string to generate.
    * @return The generated string.
    */
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

}