# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["RAILS_ENV"] = 'test'

require 'simplecov'
require 'cucumber/rails'
require 'factory_girl_rails'
require 'capybara/poltergeist'
require 'webmock/cucumber'

World(SourceHelper)
World(FactoryGirl::Syntax::Methods)

# Allow connections to localhost, required for Selenium
WebMock.disable_net_connect!(:allow_localhost => true)

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css
Capybara.ignore_hidden_elements = true
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    :timeout => 120,
    :js_errors => true,
    :inspector => true,
    :window_size => [1280, 960]
  })
end
Capybara.javascript_driver = :poltergeist

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
end

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

Cucumber::Rails::World.use_transactional_fixtures = true
Cucumber::Rails::Database.javascript_strategy = :truncation

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
# begin
#   DatabaseCleaner.strategy = :transaction
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end

Before('@javascript') do
  OmniAuth.config.test_mode = true
  omni_hash = { :provider => "github",
                :uid => "12345",
                :info => { "email" => "joe@example.com", "nickname" => "joesmith", "name" => "Joe Smith" }}
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(omni_hash)
end

After('@javascript') do
  OmniAuth.config.test_mode = false
end

Before('@couchdb') do
  put_alm_database
end

After('@couchdb') do
  delete_alm_database
end
