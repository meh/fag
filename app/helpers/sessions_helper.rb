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

module SessionsHelper
    def login (user)
        user.remember_me!
        
        cookies[:remember_token] = {
            :value   => user.remember_token,
            :expires => 23.years.from_now.utc
        }
        
        self.current_user = user
    end

    def logout
        cookies.delete(:remember_token)
        self.current_user = nil
    end

    def logged_in?
        !current_user.nil?
    end

    def current_user
        @current_user ||= user_from_remember_token
    end

    def current_user= (value)
        @current_user = value
    end

    def user_from_remember_token
        remember_token = cookies[:remember_token]
        User.find_by_remember_token(remember_token) unless remember_token.nil?
    end
end
