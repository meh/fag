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

class OceanController < ApplicationController
    def index
        @title = 'Ocean'
    end

    def projects
        @title = 'Projects'
    end

    def flow
        @flow = Flow.find(params[:id])
    end

    def new
        @type = params[:id]

        if current_user
            @name_options = { :value => current_user.name, :disabled => true }
        else
            @name_options = { :value => 'Anonymous', :disabled => false }
        end
    end

    def create
        type = params[:type]

        case type

        when 'flow'
            flow = Flow.new

            drop = Drop.new(:flow => flow, :title => params[:drop][:title], :content => params[:drop][:content])

            if current_user
                drop.user = current_user
            else
                drop.name = params[:drop][:name] || 'Anonymous'
            end

            flow.drops << drop

            if flow.save
                redirect_to "/ocean/flow/#{flow.id}"
            else
                render 'new'
            end

        when 'drop'
        
        end
    end
end
