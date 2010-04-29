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

module UsersHelper
    def text_field_options
        if current_user
            return { :value => current_user.name, :disabled => true }
        else
            return { :value => 'Anonymous', :disabled => false }
        end
    end

    def self.check_password (password, password_confirmation)
        if password.length < 1
            return "Min password length is 1."
        elsif password.length > 50
            return "Max password length is 50."
        elsif password != password_confirmation
            return "Password confirmation doesn't match the given password."
        end
    end

    def self.output (what, *args)
        UsersHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_class (user)
        if user.is_a?(User)
            return ERB::Util.h user.modes[:class].to_s
        else
            return 'anonymous'
        end
    end

    def self.output_user (user)
        if user.is_a?(User)
            return "<a href='/users/#{ERB::Util.h user.id}'>#{ERB::Util.h user.name}</a>"
        else
            return user || 'Anonymous'
        end
    end
end
