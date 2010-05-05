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

module ThemesHelper
    include SessionsHelper

    def current_theme
        theme = current_user.theme rescue nil

        if !theme || !File.exists?("#{RAILS_ROOT}/themes/#{theme}")
            theme = 'default'
        end

        return theme
    end

    def theme_path (relative)
        if relative
            "../../themes/#{current_theme}"
        else
            "#{RAILS_ROOT}/themes/#{current_theme}"
        end
    end
 end
