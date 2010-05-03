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

class ProjectsController < ApplicationController
    def index
        @title = 'Project.all'

        @projects = Project.find(:all, :conditions => 'user_id IS NOT NULL', :order => 'name')
    end

    def show
        if params[:id].match(/^\d+$/)
            @project = Project.find(params[:id])
        else
            @project = Project.find_by_name(params[:id])
        end

        if !@project
            render :text => "<span class='error'>Project not found.</span>", :layout => 'application'
            return
        end

        @title = "Project.show :#{@project.name}"
    end

    def new
        if !current_user || !current_user.modes[:can_create_projects]
            render :text => "<span class='error'>You can't create a project.</span>", :layout => 'application'
            return
        end

        @title = 'Project.new'
    end

    def create
        if !current_user || !current_user.modes[:can_create_projects]
            raise "You can't create a project."
            return
        end

        if params[:project][:name].empty? || params[:project][:tag].empty? || params[:project][:user].empty?
            flash.now[:error] = 'You have to pass every field.'
            self.new; render 'new';
            return
        end

        if !(user = User.find_by_name(params[:project][:user]))
            flash.now[:error] = "The user chosen as owner doesn't exist."
            self.new; render 'new';
            return
        end

        if !(tag = Tag.find_by_name(params[:project][:tag]))
            tag = Tag.new(:name => params[:project][:tag])
        end

        tag.type     = 'project'
        tag.priority = 9001

        tag.save

        project      = Project.create(:name => params[:project][:name])
        project.user = user
        project.tag  = tag
        project.page = "This is the page for #{params[:project][:name]}."
        project.save

        redirect_to "/projects/#{project.name}"
    end

    def edit
        @project = Project.find_by_name(params[:id])

        if !@project
            render :text => "<span class='error'>Project not found.</span>", :layout => 'application'
            return
        end

        @title = "Project.edit :#{@project.name}"
    end

    def update
    end
end
