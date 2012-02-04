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

	before do
		next if %w[GET HEAD].include? env['REQUEST_METHOD'].upcase

		if Rack::Csrf.token(env) != params[:_csrf]
			error! '418 Wrong CSRF Token', 418
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
			error! '402 Name Required' unless params[:name] && !params[:name].empty?
			error! '402 Password Required' unless params[:password] && !params[:password].empty?
			error! '302 User Already Exists', 302 if User.first(name: params[:name])

			error! '406 Name Cannot Be Only Numeric' if params[:name] =~ /^\d+$/

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

	resource :flows do
		get do
			if !params[:expression] || params[:expression] == ?*
				result = Flow.all

				if params[:limit]
					result = result.all(limit: params[:limit].to_i)
				end

				if params[:offset]
					unless params[:limit]
						result = result.all(limit: Flow.count)
					end

					result = result.all(offset: params[:offset].to_i)
				end
			else
				result = Flow.find_by_expression(params[:expression])

				if params[:offset]
					result = result[params[:offset].to_i .. -1]
				end

				if params[:limit]
					result = result[0 .. params[:limit].to_i]
				end
			end

			unless params[:no_sort]
				# sort by the newest last updated drop
				result.to_a.sort {|a, b|
					b.drops.max {|a, b|
						a.updated_at <=> b.updated_at
					}.updated_at <=> a.drops.max {|a, b|
						a.updated_at <=> b.updated_at
					}.updated_at
				}.map(&:to_hash)
			else
				result.map(&:to_hash)
			end
		end

		post do
			error! '402 Name Required' unless logged_in? || (params[:name] && !params[:name].empty?)
			error! '402 Title Required' unless params[:title]
			error! '402 Tag Required' unless params[:tags]
			error! '402 Content Required' unless params[:content]

			if params[:tags].any? { |t| Integer(t) and false rescue true }
				error! '406 Tag Cannot Be Only Numeric', 406
			end

			flow = if logged_in?
				Flow.create(title: params[:title], author_id: current_user.id)
			else
				Flow.create(title: params[:title], author_name: params[:name])
			end

			params[:tags].each {|tag|
				flow.tags.create(name: tag.downcase)
			}

			if logged_in?
				flow.drops.create(content: params[:content], author_id: current_user.id)
			else
				flow.drops.create(content: params[:content], author_name: params[:name])
			end

			flow.save

			flow
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
					params[:tags].each {|tag|
						flow.tags.each(&:destroy)
						flow.tags.create(name: tag.downcase)
					}

					flow.tags
				end

				if params[:title]
					flow.title = params[:title]
				end

				if params[:author_name]
					flow.author_name = params[:author_name]
					flow.author_id   = nil
				end

				if params[:author_id]
					error! '404 User Not Found' unless User.get(params[:author_id])

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

					result.all(order: :created_at.asc).map(&:to_hash)
				end

				post do
					error! '404 Flow Not Found', 404 unless flow = Flow.get(params[:id])

					error! '402 Name Required' unless logged_in? || (params[:name] && !params[:name].empty?)
					error! '402 Content Required' unless params[:content] && !params[:content].strip.empty?

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
			if !params[:expression] || params[:expression] == ?*
				result = Float.all

				if params[:limit]
					result = result.all(limit: params[:limit].to_i)
				end

				if params[:offset]
					unless params[:limit]
						result = result.all(limit: Flow.count)
					end

					result = result.all(offset: params[:offset].to_i)
				end
			else
				result = Float.find_by_expression(params[:expression])

				if params[:offset]
					result = result[params[:offset].to_i .. -1]
				end

				if params[:limit]
					result = result[0 .. params[:limit].to_i]
				end
			end

			result.map(&:to_hash)
		end

		post do
			error! '402 Name Required' unless logged_in? || (params[:name] && !params[:name].empty?)
			error! '402 Tag Required' unless params[:tags]
			error! '402 Files Required' unless params[:files]

			if params[:tags].any? { |t| Integer(t) and false rescue true }
				error! '406 Tag Cannot Be Only Numeric', 406
			end

			float = if logged_in?
				Float.create(title: params[:title], author_id: current_user.id)
			else
				Float.create(title: params[:title], author_name: params[:name])
			end

			params[:tags].each {|tag|
				flow.tags.create(name: tag.downcase)
			}

			if logged_in?
				flow.drops.create(content: params[:content], author_id: current_user.id)
			else
				flow.drops.create(content: params[:content], author_name: params[:name])
			end

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
				error! '404 Drop Not Found', 404 unless drop = Drop.get(params[:id])

				drop
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
end

end
