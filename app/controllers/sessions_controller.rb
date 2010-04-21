class SessionsController < ApplicationController
    def new
        @title = 'Sign in'

        if already_logged?
            render 'error'
            return
        end
    end

    def error
    end

    def already_logged?
        if current_user
            flash.now[:error] = "You're already logged in."

            return true
        end

        return false
    end
    
    def create
        if already_logged?
            render 'error'
            return
        end

        if user = User.authenticate(params[:session][:name], params[:session][:password])
            login user
            redirect_to user
        else
            flash.now[:error] = 'Invalid name/password combination.'
            @title            = 'Sign in'

            render 'new'
        end
    end

    def destroy
        logout
        redirect_to root_path
    end
end
