MyUSA Demo Application
====================

In order to authenticate with local MyUSA (account) application
---------------------

1. Create a new app in the app gallery of MyUSA
> http://localhost:&lt;port number of MyUSA (account) app [3000]&gt;/apps/new

With the following information:
> URL: http://localhost:&lt;port number of demo app [4000]&gt;
> Redirect URI: http://localhost:&lt;port number of demo app [4000]&gt;/auth/mygov/callback

2. Update values in initializers/01_mygov.rb.example and save as 01_mygov.rb
> MYGOV_CLIENT_ID: &lt;client ID produced by MyUSA app&gt;
> MYGOV_CLIENT_SECRET: &lt;client secret produced by MyUSA app&gt;

3. Start demo application!
> rails s -p &lt;port number of demo app [4000]&gt; 