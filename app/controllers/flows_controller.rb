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

        @tags = Tag.find_by_sql(%Q{
            SELECT id, name, length
        
            FROM tags, (
                SELECT tag_id, COUNT(*) AS length
            
                FROM used_tags
    
                GROUP BY tag_id
            ) AS tmp
        
            WHERE tmp.tag_id = tags.id

            ORDER BY length DESC, name ASC
        })
    end

    def projects
        @title = 'Projects'
    end

    def show
        @flow = Flow.find(params[:id])
    end

    def subscribe
        @flow = Flow.find(params[:id])

        Flow.subscribe(current_user)

        redirect_to "/flows/#{parms[:id]}"
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
            if params[:drop][:title].strip.empty?
                raise "You can't pass an empty title."
            end

            flow = Flow.new(:title => params[:drop][:title])

            flow.add_tags(params[:drop][:floats].empty? ? 'undefined' : params[:drop][:floats])
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

        flow.touch

        flow.drops << drop

        if flow.save
            redirect_to "/ocean/flow/#{flow.id}"
        else
            render 'new'
        end
    end

    def edit
        if current_user && current_user.modes[:can_edit_flow]
            @flow  = Flow.find(params[:id])
            @title = "Flow.edit #{@flow.title}"
        else
            render :text => "You can't edit flows, faggot."
        end
    end

    def update
        if !current_user || !current_user.modes[:can_edit_flow]
            raise "You can't edit flows, faggot."
        end

        if params[:flow][:title].strip.empty?
            raise "You can't pass an empty title."
        end

        flow = Flow.find(params[:id])

        UsedTag.delete_all(['flow_id = ?', flow.id])

        flow.add_tags(params[:flow][:floats].empty? ? 'undefined' : params[:flow][:floats])

        flow.save

        redirect_to "/ocean/flow/#{flow.id}"
    end
end
