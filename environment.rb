require 'rubygems'
require 'bundler'
require 'rack'
require 'rack/csrf'

Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

# load various dependencies and stuff
require 'extensions'

# database stuff
require 'data_mapper'
require 'dm-is-versioned'

Dir['models/*.rb'].each { |m| require m }

DataMapper::Model.raise_on_save_failure = true
DataMapper::setup :default, ENV['FAG_DATABASE'] || 'sqlite:///tmp/db'
DataMapper::finalize

# REST stuff
require 'grape'

Dir['api/*.rb'].each { |a| require a }

module Fag
	Domains = (ENV['FAG_DOMAINS'] || 'http://localhost').split(/\s*[;,]\s*/)
end
