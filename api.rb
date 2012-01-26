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
	version '1'

	helpers do
		def session
			env['rack.session']
		end

		def current_user
			@current_user ||= User.get(session[:id])
		end

		def logged_in?
			!!current_user
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
			session[:id] = User.get(params[:id]).tap {|u|
				error! '403 Wrong Username Or Password', 403 if !u || u.password != params[:password]
			}.id
		end
	end

	resource :user do
		post :create do
			authenticate!

			error! '403 Permission Denied', 403 unless current_user.can? 'create user'
			error! '302 User Already Exists', 302 if User.first(name: params[:name])

			User.create(name: params[:name], password: params[:password]).id
		end

		resource '/:id' do
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

			put :disable do
				authenticate!

				error! '403 Permission Denied', 403 if current_user !~ params[:id] and current_user.cannot? 'disable.user'
				error! '404 User Not Found', 404 unless user = User.get(params[:id])

				user.update(inactive: true)
			end

			put :enable do
				authenticate!

				error! '403 Permission Denied', 403 unless current_user.can? 'enable.user'
				error! '404 User Not Found', 404 unless user = User.get(params[:id])

				user.update(inactive: false)
			end
		end
	end
end

end
