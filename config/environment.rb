# Load the rails application
require File.expand_path('../application', __FILE__)
ENV['SSL_CERT_FILE'] = "/Users/greggersh/Downloads/cacert.pem"

# Initialize the rails application
MygovChangeYourName::Application.initialize!
