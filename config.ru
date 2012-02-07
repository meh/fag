#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

unless $:.unshift(File.dirname(__FILE__)) and require 'environment'
	fail 'could not require needed files'
end

if ENV['FAG_DEBUG']
	use Rack::CommonLogger
end

if ENV['FAG_PROFILE']
	use Class.new {
		def initialize (app, options = {})
			@app     = app
			@options = options
		end

		def call (env)
			if RUBY_ENGINE == 'rbx'
				require 'profiler'

				profiler = Rubinius::Profiler::Instrumenter.new
				profiler.start

				@app.call(env).tap {
					profiler.stop

					FileUtils.mkpath path rescue nil

					profiler.show File.open("#{path}/flat", 'w')
				}
			else
				require 'ruby-prof'

				RubyProf.start

				@app.call(env).tap {
					FileUtils.mkpath path rescue nil

					RubyProf::MultiPrinter.new(RubyProf.stop).print(path: path, profile: 'profile')
				}
			end
		end

		def path
			ENV['FAG_PROFILE_PATH'] || '/tmp/profile'
		end
	}
end

use Rack::Session::Cookie, secret: rand.to_s << rand.to_s << rand.to_s
use Rack::Csrf, field: 'csrf'

if Fag::Domains.empty?
	run Fag::API
else
	run lambda {|env|
		Fag::API.call(env).tap {|r|
			%w[Origin Methods Headers].each {|name|
				r[1]["Access-Control-Allow-#{name}"] = Fag::Domains.join ','
			}

			r[1]['Access-Control-Expose-Headers']    = '*'
			r[1]['Access-Control-Allow-Credentials'] = 'true'
		}
	}
end
