#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

$:.unshift(File.dirname(__FILE__)) and require 'environment'

use Rack::Session::Cookie, secret: rand.to_s << rand.to_s << rand.to_s
use Rack::Csrf

run lambda {|env|
	Fag::API.call(env).tap {|r|
		%w(Origin Methods Headers).each {|name|
			r[1]["Access-Control-Allow-#{name}"] = Fag::Domains.join ','
		}

		r[1]['Access-Control-Expose-Headers']    = '*'
		r[1]['Access-Control-Allow-Credentials'] = 'true'
	}
}
