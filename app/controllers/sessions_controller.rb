class SessionsController < ApplicationController
    def new
        @title = 'Sign in'
    end
    
    def create
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
