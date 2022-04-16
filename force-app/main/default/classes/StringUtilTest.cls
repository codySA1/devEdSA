@isTest
private with sharing class StringUtilTest {

    @isTest
    private static void generateRandomString_expectStringReturned() {
        Integer STRING_SIZE = 10;
        String testString1 = StringUtil.generateRandomString(STRING_SIZE);
        System.assertEquals(STRING_SIZE, testString1.length(), 'Expected generated string to be of correct length.');

        String testString2 = StringUtil.generateRandomString(STRING_SIZE);

        System.assertNotEquals(testString1, testString2, 'Expected a different random string to be returned on subsequent calls.');
    }
}
