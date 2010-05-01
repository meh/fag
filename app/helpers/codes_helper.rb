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

module CodesHelper
    def self.path (code)
        return "/codes/#{code.id}"
    end

    def self.output (what, *args)
        CodesHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_owner (code)
        "<span class='owner'>#{
            UsersHelper.output :user, code.user || code.name
        }</span>"
    end

    def self.output_last_code (code, template='')
        at = code.created_at
        by = UsersHelper.output(:user, ApplicationHelper.user(code))

        return templatify(template, binding)
    end
end
