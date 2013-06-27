MyUSA Demo Application
====================

In order to authenticate with local MyUSA (account) application
---------------------

1. Create a new app in the app gallery of MyUSA
http://localhost:<port number of MyUSA (account) app [3000]>/apps/new

With the following information:
URL: http://localhost:<port number of demo app [4000]>
Redirect URI: http://localhost:<port number of demo app [4000]>/auth/mygov/callback

2. Update values in initializers/01_mygov.rb.example and save as 01_mygov.rb
MYGOV_CLIENT_ID: <client ID produced by MyUSA app>
MYGOV_CLIENT_SECRET: <client secret produced by MyUSA app>

3. Start server!
> rails s -p <port number of demo app [4000]> 