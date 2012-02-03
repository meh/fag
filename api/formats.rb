#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'clj'

module Grape; module Middleware; class Base; module Formats
	def formatter_for(api_format)
		method(formatters[api_format]) rescue proc { |o| o }
	end

	%w[xml txt].each {|type|
		if const_defined? :FORMATTERS
			FORMATTERS.delete type.to_sym
		end

		if const_defined? :PARSERS
			PARSERS.delete type.to_sym
		end
	}

	CONTENT_TYPES[:clj]   = 'application/clojure'
	CONTENT_TYPES[:clj14] = 'application/clojure'

	if const_defined? :FORMATTERS
		FORMATTERS[:clj]   = :encode_clj
		FORMATTERS[:clj14] = :encode_clj14
	end

	if const_defined? :PARSERS
		PARSERS[:clj]   = :decode_clj
		PARSERS[:clj14] = :decode_clj
	end

	def encode_clj (object)
		if object.respond_to? :serializable_hash
			Clojure.dump(object.serializable_hash)
		else
			Clojure.dump(object)
		end
	end

	def encode_clj14 (object)
		if object.respond_to? :serializable_hash
			Clojure.dump(object.serializable_hash, alpha: true)
		else
			Clojure.dump(object, alpha: true)
		end
	end

	def decode_clj (object)
		Clojure.parse(object)
	end
end; end; end; end
