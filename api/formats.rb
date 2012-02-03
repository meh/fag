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

module Grape; module Middleware; class Formatter < Base
	def headers
		env.dup.inject({}){|h,(k,v)| h[k.downcase[5..-1]] = v if k.downcase.start_with? 'http_'; h}
	end
end; end; end

module Grape; module Middleware; class Base; module Formats
	CONTENT_TYPES[:clj]   = 'application/clojure'
	CONTENT_TYPES[:clj14] = 'application/clojure14'

	CONTENT_TYPES.select! { |name|
		%w(json clj clj14).include? name.to_s
	}

	FORMATTERS[:clj]   = :encode_clj
	FORMATTERS[:clj14] = :encode_clj14

	PARSERS[:clj]   = :decode_clj
	PARSERS[:clj14] = :decode_clj

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
