# heroku config:set MYGOV_HOME=https://my.usa.gov MYGOV_CLIENT_ID=register_app_with_my_usa MYGOV_SECRET_ID=register_app_with_my_usa
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mygov, ENV['MYGOV_CLIENT_ID'], ENV['MYGOV_SECRET_ID'], :client_options => {:site => ENV['MYGOV_HOME'], :token_url => "/oauth/authorize"}, :scope => ["profile", "tasks", "submit_forms", "notifications"]
end
