require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.timestamped_migrations = false
end

DOMAIN = 'fag.heroku.com'
