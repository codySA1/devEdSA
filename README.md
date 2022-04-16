# Example Meetup App

An example meetup app in Salesforce. Allows admins to create meetups that individuals can register for.

## User Experience

Users can be sent to a simple Registration Page for a given Meetup, e.g. https://exampledomain.com/lightning/n/RegistrationPage?c__code=bRFrEEBc
![image](https://user-images.githubusercontent.com/103609517/163692456-4bb67095-fc6c-41c6-8c2f-b9f5a43e2c54.png)


From here, they can enter the required fields and submit a registration.
![image](https://user-images.githubusercontent.com/103609517/163692466-da18b4db-d394-4b8c-8254-97f2d01deae9.png)

If an existing registraiton matches their email, they will be shown a notice.
![image](https://user-images.githubusercontent.com/103609517/163692490-b06cf86d-7596-423e-8133-60e13300f672.png)

Additionally, users will see a message if the event is no longer open, or has exceeded registration limit.
![image](https://user-images.githubusercontent.com/103609517/163692618-96080c6a-3607-4d88-b295-bc610215f4d6.png)


This check occurs on page load, and on submission. This limits the chance that a user spends time filling out fields before discovering they cannot submit the form.
![image](https://user-images.githubusercontent.com/103609517/163692639-508839e8-2f86-42ec-b852-a21168efd55c.png)


## Admin Notes

When meetups are created, the registration code is generated automatically. It's length is equal to the custom field max length (e.g. 8 characters). This code should be used for the URLs with the c__code query param.

![Screen Shot 2022-04-16 at 6 01 46 PM](https://user-images.githubusercontent.com/103609517/163692682-5287cc0d-0676-4b13-b7f2-8e0f581c0eb2.png)


If an individual attempts to view the page with a malformed or missing registration code, they'll see a friendly error message.
![image](https://user-images.githubusercontent.com/103609517/163692691-7bbb7ad7-7850-470d-8d4e-cf1f96b401f9.png)


Registrations can also be created manually, and triggers will enforce the validations (capacity, meetup status, duplicate emails, etc.).
![image](https://user-images.githubusercontent.com/103609517/163692705-ae2de42f-eb2b-4508-95bd-a4fab2c5251f.png)

