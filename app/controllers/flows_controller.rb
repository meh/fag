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

class FlowsController < ApplicationController
    def index
        @title = 'Ocean'
    end

    def projects
        @title = 'Projects'
    end

    def show
        @flow = Flow.find(params[:id])
    end

    def new
        @type = params[:type]
        @flow = params[:id]

        if current_user
            @name_options = { :value => current_user.name, :disabled => true }
        else
            @name_options = { :value => 'Anonymous', :disabled => false }
        end
    end

    def create
        type = params[:type]

        if params[:type] == 'flow'
            flow = Flow.new(:title => params[:drop][:title])
        elsif params[:type] == 'drop'
            flow = Flow.find(params[:flow])
        end

        drop = Drop.new(:flow => flow)

        if current_user
            drop.user    = current_user
            drop.content = Drop.parse(params[:drop][:content], drop.user)
        else
            drop.name    = params[:drop][:name] || 'Anonymous'
            drop.content = Drop.parse(params[:drop][:content], drop.name)
        end

        flow.drops << drop

        if flow.save
            redirect_to "/ocean/flow/#{flow.id}"
        else
            render 'new'
        end
    end
end
