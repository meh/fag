#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Fag

class API < Grape::API
	version ?1, using: :header, vendor: 'fag'

	helpers do
		def session
			env['rack.session']
		end

		def current_user
			return unless session[:user]

			@current_user ||= User.get(session[:user])
		end

		def logged_in?
			!!current_user
		end

		def authenticate!
			logged_in? or error! '401 Must Log In', 401
		end
	end

	unless ENV['FAG_DEVELOPMENT']
		rescue_from :all do |e|
			print "[#{Time.now}] "
			print "From: #{caller[0, 1].join "\n"}\n"
			print "#{e.class}: #{e.message}\n"
			print e.backtrace.to_a.join "\n"
			print "\n\n"

			Rack::Response.new(['500 Something Went Wrong'], 500, { 'Content-Type' => 'text/error' }).finish
		end
	end

	resource :csrf do
		get do
			Rack::Csrf.token(env)
		end

		get '/renew' do
			session.delete(Rack::Csrf.key)

			Rack::Csrf.token(env)
		end
	end

	resource :auth do
		get do
			logged_in?
		end

		post do
			user = User.get(params[:name] || params[:id])

			if !user || user.password != params[:password]
				error! '403 Wrong Username Or Password', 403
			end

			session[:user] = user.id
		end
	end

	resource :users do
		post do
			error! '402 Name Required', 402 unless params[:name] && !params[:name].empty?
			error! '402 Password Required', 402 unless params[:password] && !params[:password].empty?

			params[:name] = params[:name].gsub(/[[:space:]]+/, ' ').strip

			error! '406 Name Cannot Be Only Numeric', 406 if params[:name] =~ /^\d+$/

			error! '409 User Already Exists', 409 if User.first(name: params[:name])

			User.create(name: params[:name], password: params[:password])
		end

		resource '/:id' do
			get do
				error! '404 User Not Found', 404 unless user = User.get(params[:id])

				user
			end

			put :password do
				authenticate!

				error! '403 Permission Denied', 403 if current_user !~ params[:id] and current_user.cannot? 'change user password'
				error! '404 User Not Found', 404 unless user = User.get(params[:id])

				user.update(password: params[:password])
			end

			get :powers do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'see user powers'
				error! '404 User Not Found', 404 unless user = User.get(params[:id])

				user.powers
			end

			resource :can do
				get '/:what' do
					authenticate!

					user = User.get(params[:id])

					error! '403 Permission Denied', 403 unless user =~ current_user or current_user.can? 'see user powers'
					error! '404 User Not Found', 404 unless user

					user.can?(params[:what])
				end

				put do
					authenticate!

					error! '403 Permission Denied', 403 unless current_user.can? 'change user powers'
					error! '404 User Not Found', 404 unless user = User.get(params[:id])

					params.each {|name, value|
						next if name == :id

						user.can!(name, value || true)
					}
				end
			end

			resource :cannot do
				get '/:what' do
					authenticate!

					user = User.get(params[:id])

					error! '403 Permission Denied', 403 unless user =~ current_user or current_user.can? 'see user powers'
					error! '404 User Not Found', 404 unless user

					user.cannot?(params[:what])
				end

				put do
					authenticate!

					error! '403 Permission Denied', 403 unless current_user.can? 'change user powers'
					error! '404 User Not Found', 404 unless user = User.get(params[:id])

					params.each {|name, value|
						next if name == :id

						user.cannot!(name)
					}
				end
			end
		end
	end

	resource :tags do
		get '/:id' do
			Tag.get(params[:id])
		end
	end

	resource :flows do
		get do
			result = if !params[:expression] || params[:expression] == ?*
				Flow.all
			else
				Flow.find_by_expression(params[:expression]) or next []
			end

			unless params[:no_sort]
				result = result.all(order: :updated_at.desc)
			end

			if params[:limit]
				result = result.all(limit: params[:limit].to_i)
			end

			if params[:offset]
				unless params[:limit]
					result = result.all(limit: Flow.count)
				end

				result = result.all(offset: params[:offset].to_i)
			end

			result.unlazy.map(&:to_hash)
		end

		post do
			error! '402 Name Required', 402 unless logged_in? || (params[:name] && !params[:name].empty?)
			error! '402 Title Required', 402 unless params[:title]
			error! '402 Tag Required', 402 unless params[:tags]
			error! '402 Content Required', 402 unless params[:content]

			if params[:tags].any?(&:integer?)
				error! '406 Tag Cannot Be Only Numeric', 406
			end

			flow = if logged_in?
				Flow.create(title: params[:title], author_id: current_user.id)
			else
				Flow.create(title: params[:title], author_name: params[:name])
			end

			flow.add_tags(params[:tags].map(&:downcase))

			if logged_in?
				flow.drops.create(content: params[:content], author_id: current_user.id)
			else
				flow.drops.create(content: params[:content], author_name: params[:name])
			end

			flow.save

			flow
		end

		get :tags do
			Hash[Tag.all.unlazy.map {|tag|
				[tag.name, tag.count_flows]
			}]
		end

		resource '/:id' do
			get do
				error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

				flow
			end

			put do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'change flows'
				error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

				if params[:tags]
					flow.clean_tags
					flow.add_tags(params[:tags].map(&:downcase))
				end

				if params[:title]
					flow.title = params[:title]
				end

				if params[:author_name]
					flow.author_name = params[:author_name]
					flow.author_id   = nil
				end

				if params[:author_id]
					error! '404 User Not Found', 404 unless User.get(params[:author_id])

					flow.author_id   = params[:author_id].to_i
					flow.author_name = nil
				end

				flow.save
			end

			delete do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'delete flows'
				error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

				flow.destroy
			end

			resource :drops do
				get do
					error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

					result = flow.drops

					if params[:limit]
						result = result.all(limit: params[:limit].to_i)
					end

					if params[:offset]
						unless params[:limit]
							result = result.all(limit: Flow.count)
						end

						result = result.all(offset: params[:offset].to_i)
					end

					result = result.all(order: :created_at.asc)
					
					result.unlazy.map(&:to_hash)
				end

				post do
					error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

					error! '402 Name Required', 402 unless logged_in? || (params[:name] && !params[:name].empty?)
					error! '402 Content Required', 402 unless params[:content] && !params[:content].strip.empty?

					if logged_in?
						flow.drops.create(content: params[:content], title: params[:title], author_id: current_user.id)
					else
						flow.drops.create(content: params[:content], title: params[:title], author_name: params[:name])
					end
				end
			end
		end
	end

	resource :floats do
		get do
			result = if !params[:expression] || params[:expression] == ?*
				Float.all
			else
				Float.find_by_expression(params[:expression]) or next []
			end

			unless params[:no_sort]
				result = result.all(order: :updated_at.desc)
			end

			if params[:limit]
				result = result.all(limit: params[:limit].to_i)
			end

			if params[:offset]
				unless params[:limit]
					result = result.all(limit: Float.count)
				end

				result = result.all(offset: params[:offset].to_i)
			end

			result.unlazy.map(&:to_hash)
		end

		post do
			error! '402 Name Required', 402 unless logged_in? || (params[:name] && !params[:name].empty?)
			error! '402 Tag Required', 402 unless params[:tags]
			error! '402 Files Required', 402 unless params[:files]

			if params[:tags].any? { |t| Integer(t) and false rescue true }
				error! '406 Tag Cannot Be Only Numeric', 406
			end

			float = if logged_in?
				Float.create(title: params[:title], author_id: current_user.id)
			else
				Float.create(title: params[:title], author_name: params[:name])
			end

			float.add_tags(params[:tags].map(&:downcase))
			float.save

			float
		end

		resource '/:id' do
			get do
				error! '404 Float Not Found', 404 unless float = Float.get(params[:id])

				float
			end

			get :files do
				error! '404 Float Not Found', 404 unless float = Floa.get(params[:id])

				float.files.map(&:to_hash)
			end

			delete do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'delete floats'
				error! '404 Float Not Found', 404 unless float = Float.get(params[:id])

				float.destroy
			end
		end
	end

	resource :drops do
		resource '/:id' do
			get do
				if params[:id].integer? && !params[:array]
					error! '404 Drop Not Found', 404 unless drop = Drop.get(params[:id])

					drop
				else
					ids = params[:id].split(/\s*[,;]\s*/).map(&:to_i)

					if params[:offset]
						ids = ids[params[:offset].to_i .. -1]
					end

					if params[:limit]
						ids = ids[0 .. params[:limit].to_i]
					end

					drops = Hash[Drop.all(id: ids).unlazy.map { |d| [d.id, d.to_hash] }]

					ids.map { |id| drops[id] }
				end
			end

			put do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'change drops'
				error! '404 Drop Not Found', 404 unless drop = Drop.get(params[:id])

				if params[:title]
					drop.title = params[:title]
				end

				if params[:author_name]
					drop.author_name = params[:author_name]
					drop.author_id   = nil
				end

				if params[:author_id]
					drop.author_id   = params[:author_id].to_i
					drop.author_name = nil
				end

				if params[:content]
					drop.content = params[:content]
				end

				drop.save
			end

			delete do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'delete drops'
				error! '404 Drop Not Found', 404 unless drop = Drop.get(params[:id])

				drop.destroy
			end
		end
	end

	resource :metadata do
		helpers do
			def get_model (what, id)
				model = case what.downcase.to_sym
					when :tag, :tags   then Tag
					when :flow, :flows then Flow
					when :drop, :drops then Drop
				end

				return unless model

				model.get(id.to_i)
			end
		end

		resource '/:what/:id' do
			get do
				error! '404 Model Not Found', 404 unless what = get_model(params[:what], params[:id])

				what.metadata
			end

			put do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'change metadata'
				error! '404 Model Not Found', 404 unless what = get_model(params[:what], params[:id])

				what.update(metadata: what.metadata.merge(params[:data]))
			end

			delete do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'clear metadata'
				error! '404 Model Not Found', 404 unless what = get_model(params[:what], params[:id])

				what.update(metadata: {})
			end
		end
	end
end

end
