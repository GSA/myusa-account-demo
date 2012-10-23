Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mygov, MYGOV_CLIENT_ID, MYGOV_SECRET_ID
end