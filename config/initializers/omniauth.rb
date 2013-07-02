# MYGOV_HOME="https://my.usa.gov"

# MYGOV_CLIENT_ID = "REGISTER APP WITH MYUSA"
# MYGOV_SECRET_ID = "REGISTER APP WITH MYUSA"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mygov, MYGOV_CLIENT_ID, MYGOV_SECRET_ID, :client_options => {:site => MYGOV_HOME, :token_url => "/oauth/authorize"}, :scope => ["profile", "tasks", "submit_forms", "notifications"]
end
