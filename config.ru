#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

$:.unshift(File.dirname(__FILE__))
require 'environment'

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
