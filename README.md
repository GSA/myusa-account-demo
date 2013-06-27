This is an example of how to use the MyGov API to build an application.

This app demonstrates a number of things:

1.  Authorizing the app to retrieve a citizen's MyGov profile information.
2.  Getting a pre-filled PDF from MyGov
3.  Creating a task for a user.

MyUSA Demo Application
====================

In order to authenticate with local MyUSA (account) application
---------------------

1. Create a new app in the app gallery
http://localhost:<port number of MyUSA (account) app [3000]>/apps/new

With the following information:
URL: http://localhost:<port number of demo app [4000]>
Redirect URI: http://localhost:<port number of demo app [4000]>/auth/mygov/callback

2. Update values in initializers/01_mygov.rb.example and save as 01_mygov.rb
MYGOV_CLIENT_ID: <client ID produced by your local app>
MYGOV_CLIENT_SECRET: <client secret produced by your local app>

3. Start server!
> rails s -p <port number of demo app [4000]>