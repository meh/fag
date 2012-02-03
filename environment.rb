#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'rubygems'
require 'bundler'
require 'rack'
require 'rack/csrf'

Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

# some dependencies and extensions
require 'json'
require 'boolean/expression'

# database stuff
require 'data_mapper'
require 'dm-is-versioned'

(['models/helpers.rb'] + Dir['models/*.rb']).uniq.each { |m| require m }

DataMapper::Model.raise_on_save_failure = true
DataMapper::setup :default, ENV['FAG_DATABASE'] || 'sqlite:///tmp/db'
DataMapper::finalize

# REST stuff
require 'grape'

(['api/formats.rb'] + Dir['api/*.rb']).uniq.each { |a| require a }

module Fag
	Domains = (ENV['FAG_DOMAINS'] || '').split(/\s*[;,]\s*/)
end
