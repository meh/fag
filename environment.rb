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

module Fag

module Serializable
	def self.included (klass)
		class << klass
			def serialize_as (&block)
				define_method :serializable_hash, &block
				define_method :to_hash, &block
			end
		end
	end
end

module Authored
	def self.included (klass)
		klass.instance_eval {
			property :author_name, DataMapper::Property::String, required: false
			property :author_id,  DataMapper::Property::Integer, required: false

			property :created_at, DataMapper::Property::DateTime
			property :updated_at, DataMapper::Property::DateTime
		}
	end

	def anonymous?; author_id.nil?; end

	def author
		anonymous? ? Anonymous.new(author_name) : User.get(author_id)
	end
end

module Versioned
	def self.included (klass)
		klass.instance_eval {
			is_versioned on: :updated_at
		}
	end
end

end

# database stuff
require 'data_mapper'
require 'dm-is-versioned'

Dir['models/*.rb'].each { |m| require m }

DataMapper::Model.raise_on_save_failure = true
DataMapper::setup :default, ENV['FAG_DATABASE'] || 'sqlite:///tmp/db'
DataMapper::finalize

# REST stuff
require 'grape'

module Grape; module Middleware; class Base; module Formats
	require 'clj'

	%w[xml txt].each {|type|
		CONTENT_TYPES.delete type.to_sym
		FORMATTERS.delete type.to_sym
		PARSERS.delete type.to_sym
	}

	CONTENT_TYPES[:clj] = 'application/clojure'
	FORMATTERS[:clj]    = :encode_clj
	PARSERS[:clj]       = :decode_clj

	def encode_clj(object)
		if object.respond_to? :serializable_hash
			Clojure.dump(object.serializable_hash)
		elsif object.respond_to? :to_clj
			object.to_clj
		else
			Clojure.dump(object)
		end
	end

	def decode_clj(object)
		Clojure.parse(object)
	end
end; end; end; end

Dir['api/*.rb'].each { |a| require a }

module Fag
	Domains = (ENV['FAG_DOMAINS'] || 'http://localhost').split(/\s*[;,]\s*/)
end
