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
        if params[:id].match(/^\d+$/)
            @user = User.find(params[:id])
        else
            @user = User.find_by_name(params[:id])
        end

        @title = "User : #{@user.name}"
    end

    def already_logged?
        if current_user
            flash.now[:error] = "You're already logged in."

            return true
        end

        return false
    end

    def new
        if already_logged?
            @user = current_user
            render 'show'
            return
        end

        @title = 'Sign up'
    end

    def create
        if params[:user][:name].length < 1 || params[:user][:name].length > 50
            flash.now[:error] = "The name isn't long enough. (1 .. 50)"
            self.new; render 'new'
            return
        end

        if error = UsersHelper.check_password(params[:user][:password], params[:user][:password_confirmation])
            flash.now[:error] = error
            self.new; render 'new'
            return
        end

        @user          = User.new(params[:user])
        @user.password = params[:user][:password]
        
        if @user.save
            login @user
            redirect_to @user
        else
            self.new; render 'new'
        end
    end

    def edit
        if params[:id].match(/^\d+$/)
            @user = User.find(params[:id])
        else
            @user = User.find_by_name(params[:id])
        end

        if current_user.id == @user.id || current_user.modes[:can_edit_users]
            @title = "User.edit #{@user.name}"
        else
            render :text => "You can't edit other user's data :("
        end
    end

    def update
        if params[:id].match(/^\d+$/)
            user = User.find(params[:id])
        else
            user = User.find_by_name(params[:id])
        end

        if current_user.id != user.id && !current_user.modes[:can_edit_users]
            raise "You cannot edit other users' data."
        end

        if !params[:user][:email].empty? && !params[:user][:email].match(/[\w\.]+@[\w\.]+\.\w{2,6}/)
            flash.now[:error] = 'The email address is not valid.'
            self.edit; render 'edit'
            return
        end

        user.email = params[:user][:email]

        if params[:user][:email_show].to_i == 1
            user.modes[:email_show] = true
        else
            user.modes[:email_show] = false
        end

        if current_user.modes[:can_change_modes]
            modes = eval(params[:user][:modes]) rescue nil

            if modes.is_a?(Hash)
                user.modes = modes
            end
        end

        if current_user.modes[:can_change_user_name]
            user.name = params[:user][:name]
        end

        user.stuff = params[:user][:stuff]

        user.home_expression = params[:user][:home_expression]
        user.theme           = params[:user][:theme]

        if current_user.modes[:can_change_user_modes] && !params[:user][:modes].empty?
            user.modes = eval(params[:user][:modes])
        end

        if user.save
            redirect_to user_path user
        else
            self.edit; render 'edit'
        end
    end

    def change_password
        user = User.find(params[:id])

        if current_user.id != user.id && !current_user.modes[:can_change_user_password]
            render :text => "You can't change other users' passwords."
            return
        end

        if !user.password?(params[:change][:old_password]) && !current_user.modes[:can_change_user_password]
            flash.now[:error] = "Wrong password"
            params[:id] = user.id.to_s; self.edit; render 'edit'
            return
        end

        if error = UsersHelper.check_password(params[:change][:new_password], params[:change][:new_password])
            flash.now[:error] = error
            params[:id] = user.id.to_s; self.edit; render 'edit'
            return
        end

        user.set_password params[:change][:new_password]
        user.save

        redirect_to user_path user
    end

    def delete
        user = User.find(params[:id])

        if current_user.id != user.id && !current_user.modes[:can_delete_users]
            render :text => "You can't delete other users :("
            return
        end

        Drop.update_all({ :user_id => nil, :name => user.name }, ['user_id = ?', user.id])
        Code.update_all({ :user_id => nil, :name => user.name }, ['user_id = ?', user.id])

        user.delete

        redirect_to root_path
    end
end
