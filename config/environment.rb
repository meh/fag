require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.timestamped_migrations = false
end

DOMAIN = '127.0.0.1'
