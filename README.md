MyUSA Demo Application
====================

In order to authenticate with local MyUSA (account) application
---------------------

1. Create a new app in the app gallery of MyUSA
> https://my.usa.gov/apps/new

With the following information:
> URL: http://demoapp.com

> Redirect URI: http://demoapp.com/auth/mygov/callback

2. Create local_env.yml file with the following information:

> MYGOV_HOME: https://my.usa.gov

> MYGOV_CLIENT_ID: &lt;client ID produced by MyUSA app&gt;

> MYGOV_CLIENT_SECRET: &lt;client secret produced by MyUSA app&gt;


3. Start demo application!
> rails s