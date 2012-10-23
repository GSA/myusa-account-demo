# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.include IntegrationSpecHelper, :type => :request
end

Capybara.default_host = 'http://example.org'

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:mygov, {
  :uid => '12345',
  :name => 'Greg Gershman',
  :extra => {
    :raw_info => {
      :id => '12345',
      :title => 'Mr.',
      :first_name => 'Joe',
      :middle_name => 'Q.',
      :last_name => 'Citizen',
      :address => '123 Evergreen Terr',
      :city => 'Springfield',
      :state => 'IL',
      :zip => '12345',
      :phone_number => '1233455667',
      :mobile_number => '2345678901',
      :email => 'joe@citizen.org',
      :date_of_birth => '1990-01-01'
    }
  },
  :credentials => {
    :token => 'FAKE_TOKEN'
  }
})