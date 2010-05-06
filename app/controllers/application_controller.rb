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

class ApplicationController < ActionController::Base
    helper :all
    include ThemesHelper

    protect_from_forgery

    filter_parameter_logging :password

    before_filter [:ban_hammer, :set_theme, :log_last_actions]

    layout :theme_layout

    private

    def ban_hammer
        ip = request.remote_ip

        Ban.all.each {|ban|
            if ip.match(Regexp.new(ban.ip.gsub('*', '.*?').gsub('?', '.')))
                render :text => '/me uses BANHAMER on you'
                return false
            end
        }
    end

    def set_theme
        self.prepend_view_path("#{RAILS_ROOT}/themes/#{current_theme}")
    end

    def theme_layout
        "#{RAILS_ROOT}/themes/#{current_theme}/layouts/application.html.erb"
    end

    def log_last_actions
        
    end
end
