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
    protect_from_forgery

    filter_parameter_logging :password

  protected
    def render_optional_error_file (status_code)
        status = interpret_status(status_code)
        render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
    end
end
