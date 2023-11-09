# flutter_test_project
First download the code from git hub link.
Open 'flutter_test_project' folder in android studio.
Open terminal and fire 'pub get' command for getting all packages.
Please select device from device dropdown and click on play icon or fire 'flutter run' command in terminal.

In the project there are 2 important files: main.dart and opendetailsPage.dart
In main.dart file person detail's list related code is present.
If you want see data of more pages then set 'maxPages' variable according to that currently it has been set to 3.

Supported Platform:
a. Android 
b. iOS
c. Web

Functionality :
1. Fetching Person's data using fake API (https://fakerapi.it/) and displayed.
a. Initial load of the application only fetching first 10 persons data from (https://fakerapi.it/)
b. Implemented infinite scrolling (mobile) and 'Load more' (web) to display the next data.
c. As per requirement, at the 4th attempt, instead of loading, shown that there is no more data to prevent
the user from loading the next set.
d. Applied a pull to refresh (mobile) and refresh button (web) to go to clear the list and
fetch the first page.
2. The list displayed with following data:
   a. Name
   b. Email
   c. Image
3. User can see person's detail information by clicking any person's name in list of persons.