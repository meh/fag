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
    def home
        if current_user
            params[:expression] = current_user.modes[:home_expression]
        end

        self.search
        render 'search'
    end

    def index
        @title = 'Ocean'

        @tags = Tag.find_by_sql(%{
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
        value.downcase!
        value.gsub!(/(\s+and\s+|\s*&&\s*)/i, ' && ')
        value.gsub!(/(\s+or\s+|\s*\|\|\s*)/i, ' || ')
        value.gsub!(/(\s+not\s+|\s*!\s*)/i, ' !')
        value.gsub!(/\(\s*!/, '(!')

        joins      = String.new
        names      = []
        expression = value.clone

        expression.scan(/(("(([^\\"]|\\.)*)")|([^\s&!|()]+))/) {|match|
            names.push((match[2] || match[4]).downcase)
        }

        names.compact!
        names.uniq!

        names.each_index {|index|
            joins << %{
                LEFT JOIN (
                    SELECT ____u_t_#{index}.flow_id
                    
                    FROM used_tags AS ____u_t_#{index}
                    
                    INNER JOIN tags AS ____t_#{index}
                        ON ____u_t_#{index}.tag_id = ____t_#{index}.id AND ____t_#{index}.name = ?
                ) AS ____t_i_#{index}
                    ON flows.id = ____t_i_#{index}.flow_id
            }

            if (replace = names[index]).match(/[\s&!|]/)
                replace = %{"#{replace}"}
            end

            expression.gsub!(/([\s()]|\G)!\s*#{Regexp.escape(replace)}([\s()]|$)/, "\\1 ____t_i_#{index}.flow_id IS NULL \\2")
            expression.gsub!(/([\s()]|\G)#{Regexp.escape(replace)}([\s()]|$)/, "\\1 ____t_i_#{index}.flow_id IS NOT NULL \\2")
        }

        expression.gsub!(/\s*&&\s*/i, ' AND ')
        expression.gsub!(/\s*\|\|\s*/i, ' OR ')

        return [joins, names, expression]
    end

    def search
        @search = params[:expression]

        if @search && !@search.empty?
            @joins, @names, @expression = self.expression_to_sql(@search)

            @flows = Flow.find_by_sql([%{
                SELECT DISTINCT flows.*
                
                FROM flows

                #{@joins}
                
                WHERE #{@expression}

                ORDER BY flows.updated_at DESC
            }].concat(@names))
        else
            @flows = Flow.find(:all, :order => 'updated_at DESC')
        end
    end

    def show
        @flow = Flow.find(params[:id])
    end

    def new
        @title = 'Flow.new'

        if params[:tag]
            @tag = %{"#{params[:tag]}"}
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

        cap = current_user ? current_user.modes[:priority_cap].to_i : 2000

        flow = Flow.new(:title => params[:drop][:title])
        flow.add_tags(params[:drop][:floats].empty? ? 'undefined' : params[:drop][:floats], cap)

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
            render :text => "<span class='error'>You can't edit flows, faggot.</span>", :layout => 'application'
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

    def stop
        flow = Flow.find(params[:id])

        if !current_user || !current_user.modes[:can_stop_flows]
            raise "You can't stop a flow."
        end

        flow.stopped = true
        flow.save

        redirect_to "/ocean/flow/#{flow.id}"
    end

    def restart
        flow = Flow.find(params[:id])

        if !current_user || !current_user.modes[:can_restart_flows]
            raise "You can't stop a flow."
        end

        flow.stopped = false

        redirect_to "/ocean/flow/#{flow.id}"
    end

    def drop
        case params[:what]

        when 'new'
            if !params[:id]
                render :text => "<span class='error'>On what flow should I drop, Sir?</span>", :layout => 'application'
                return
            end

            @flow = Flow.find(params[:id])

            if @flow.closed
                render :text => "<span class='error'>You can't drop in a stopped flow.</span>", :layout => 'application'
                return
            end

        when 'create'
            flow = Flow.find(params[:flow])

            if flow.stopped
                render :text => "<span class='error'>You can't drop in a stopped flow.</span>", :layout => 'application'
                return
            end

            if current_user
                cap = current_user.modes[:priority_cap].to_i
            else
                cap = 2000
            end

            Tag.find_by_flow(flow).each {|tag|
                if tag.priority.to_i < cap
                    render :text => "<span class='error'>You don't have the right permissions to drop in this flow.</span>", :layout => 'application'
                    return
                end
            }

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

    def subscriptions
        if !current_user
            redirect_to root_path
            return
        end

        @flows = Flow.find_by_sql(%{
            SELECT flows.*

            FROM flows, subscriptions

            WHERE user_id = #{current_user.id}

            ORDER BY updated_at DESC
        })
    end

    def subscribe
        if current_user
            flow = Flow.find(params[:id])

            current_user.subscribe(flow)
        end

        redirect_to "/flows/#{params[:id]}"
    end

    def unsubscribe
        if current_user
            flow = Flow.find(params[:id])
            
            current_user.unsubscribe(flow)
        end

        redirect_to "/flows/#{params[:id]}"
    end
end
