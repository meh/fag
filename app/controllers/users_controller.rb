# fag, forums are gay
#
# Copyleft meh. [http://meh.doesntexist.org | meh.ffff@gmail.com]
#
# This file is part of fag.
#
# fag is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fag is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with fag. If not, see <http://www.gnu.org/licenses/>.

class UsersController < ApplicationController
    def index
        @users = User.all
        @title = 'Users'
    end

    def show
        @user  = User.find(params[:id])
        @title = "User : #{@user.name}"
    end

    def new
        @user  = User.new
        @title = 'Sign up'
    end

    def edit
        user = User.find(params[:id])

        if current_user.id == user.id || current_user.attributes[:can_edit]
            @title = "Edit: #{current_user.name}"
            @user  = user
        else
            redirect_to root_path
        end
    end

    def create
        @user = User.new(params[:user])
        
        if @user.save
            login @user
            redirect_to @user
        else
            @title = 'Sign up'
            render 'new'
        end
    end
end
