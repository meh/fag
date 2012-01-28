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
	version ?1

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
			user = User.get(params[:id])

			if !user || user.password != params[:password]
				error! '403 Wrong Username Or Password', 403
			end

			session[:user] = user.id
		end
	end

	resource :user do
		post :create do
			error! '302 User Already Exists', 302 if User.first(name: params[:name])

			User.create(name: params[:name], password: params[:password]).id
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

					error! '403 Permission Denied', 403 unless current_user.can? 'change.user.powers'
					error! '404 User Not Found', 404 unless user = User.get(params[:id])

					params.each {|name, value|
						next if name == :id

						user.cannot!(name)
					}
				end
			end
		end
	end

	resource :flow do
		resource '/:id' do
			get do
				error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

				flow
			end

			post '/drop' do
				error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

				error! '403 Name Required' if logged_in? && !params[:name]
				error! '403 Content Required' unless params[:content] && !params[:content].strip.empty?

				if logged_in?
					flow.drops.create(content: params[:content], title: params[:title], author_id: current_user.id)
				else
					flow.drops.create(content: params[:content], title: params[:title], author_name: params[:name])
				end
			end
		end

		post '/create' do
			error! '403 Name Required' if logged_in? && !params[:name]
			error! '403 Title Required' unless params[:title]
			error! '403 Content Required' unless params[:content]
			error! '403 Tag Required' unless params[:tags]

			flow = if logged_in?
				Flow.create(title: params[:title], author_id: current_user.id)
			else
				Flow.create(title: params[:title], author_name: params[:name])
			end

			JSON.parse(params[:tags]).each {|tag|
				flow.tags.create(name: tag)
			}

			if logged_in?
				flow.drops.create(content: params[:content], author_id: current_user.id)
			else
				flow.drops.create(content: params[:content], author_name: params[:name])
			end

			flow.save

			flow
		end
	end

	get :flows do
		error! '404 Expression Needed' unless params[:expression]

		result = Flow.find_by_expression(params[:expression])

		if params[:limit]
			result = result.all(limit: params[:limit].to_i)
		end

		if params[:offset]
			unless params[:limit]
				result = result.all(limit: Flow.count)
			end

			result = result.all(offset: params[:offset].to_i)
		end

		result.map(&:to_hash)
	end

	resource :drop do
		get '/:id' do
			error! '404 Drop Not Found', 404 unless drop = Drop.get(params[:id])

			drop
		end
	end
end

end
