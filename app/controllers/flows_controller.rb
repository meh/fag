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
            SELECT id, name, type, priority, length
        
            FROM tags, (
                SELECT tag_id, COUNT(*) AS length
            
                FROM used_tags
    
                GROUP BY tag_id
            ) AS tmp
        
            WHERE tmp.tag_id = tags.id

            ORDER BY length DESC, name ASC
        })
    end

    def expression_to_sql (value)
        value.gsub!(/(\s+and\s+|\s*&&\s*)/i, ' && ')
        value.gsub!(/(\s+or\s+|\s*\|\|\s*)/i, ' || ')
        value.gsub!(/(\s+not\s+|\s*!\s*)/i, ' !')

        joins      = String.new
        names      = []
        expression = value.clone

        expression.scan(/(("(([^\\"]|\\.)*)")|([^\s&!|]+))/) {|match|
            names.push(match[2] || match[4])
        }

        names.uniq!

        names.each_index {|index|
            joins << %Q{
                LEFT JOIN (
                    SELECT ____u_t_#{index}.flow_id
                    
                    FROM used_tags AS ____u_t_#{index}
                    
                    INNER JOIN tags AS ____t_#{index}
                        ON ____u_t_#{index}.tag_id = ____t_#{index}.id AND ____t_#{index}.name = ?
                ) AS ____t_i_#{index}
                    ON flows.id = ____t_i_#{index}.flow_id
            }

            expression.gsub!(/!\s*#{Regexp.escape(names[index])}/, " ____t_i_#{index}.flow_id IS NULL ")
            expression.gsub!(/#{Regexp.escape(names[index])}/, " ____t_i_#{index}.flow_id IS NOT NULL ")
        }

        expression.gsub!(/\s*&&\s*/i, ' AND ')
        expression.gsub!(/\s*\|\|\s*/i, ' OR ')

        return [joins, names, expression]
    end

    def search
        @search = params[:tag]

        if @search
            @joins, @names, @expression = self.expression_to_sql(@search)

            @flows = Flow.find_by_sql([%Q{
                SELECT DISTINCT flows.*
                
                FROM flows

                #{@joins}
                
                WHERE #{@expression}
            }].concat(@names))
        else
            @flows = Flow.find(:all, :order => 'updated_at DESC')
        end
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
        @title = 'Flow.new'

        if params[:tag]
            @tag = %Q{"#{params[:tag]}"}
        end
    end

    def create
        if params[:drop][:title].strip.empty?
            flash.now[:error] = "You can't pass an empty title."
            self.new; render 'new'
            return
        end

        if params[:drop][:content].empty?
            flash.now[:error] = "You can't pass an empty content."
            self.new; render 'new'
            return
        end

        flow = Flow.new(:title => params[:drop][:title])
        flow.add_tags(params[:drop][:floats].empty? ? 'undefined' : params[:drop][:floats])

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
        if current_user && current_user.modes[:can_edit_flows]
            @flow  = Flow.find(params[:id])
            @title = "Flow.edit #{@flow.title}"
        else
            render :text => "You can't edit flows, faggot."
        end
    end

    def update
        if !current_user || !current_user.modes[:can_edit_flows]
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

    def delete
        flow = Flow.find(params[:id])

        if current_user && current_user.modes[:can_delete_flows]
            Drop.delete_all(['flow_id = ?', flow.id])
            UsedTag.delete_all(['flow_id = ?', flow.id])
            flow.delete
        end

        redirect_to '/ocean'
    end

    def drop
        case params[:what]

        when 'new'
            if !params[:id]
                render :text => "On what flow should I drop, Sir?"
                return
            end

            @flow = params[:id]

        when 'create'
            flow = Flow.find(params[:flow])

            if params[:drop][:content].empty?
                flash.now[:error] = "You can't pass an empty content."
                params.merge!({ :what => 'new', :id => flow.id }); self.drop; render 'drop'
                return
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
                params.merge!({ :what => 'new', :id => flow.id }); self.drop; render 'drop'
            end

        when 'delete'
            drop = Drop.find(params[:id])

            if current_user && current_user.modes[:can_delete_drops]
                Drop.delete(params[:id])
            end

            redirect_to "/ocean/flow/#{drop.flow.id}"
        end
    end

    def subcriptions
        if !current_user
            redirect_to root_path
            return
        end
    end

    def subcribe

    end

    def unsubscribe

    end
end
