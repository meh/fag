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

        if @projects.empty?
            render :text => 'There are no projects ;_;', :layout => 'application'
        end
    end

    def show
        if params[:id].match(/^\d+$/)
            @project = Project.find(params[:id]) rescue nil
        else
            @project = Project.find_by_name(params[:id]) rescue nil
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
            tag = Tag.new(:name => params[:project][:tag].downcase)
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
        @project = Project.find_by_name(params[:id]) rescue nil

        if !@project
            render :text => "<span class='error'>Project not found.</span>", :layout => 'application'
            return
        end

        @title = "Project.edit :#{@project.name}"
    end

    def update
        project = Project.find(params[:project][:id]) rescue nil

        if !project
            render :text => "<span class='error'>Project not found.</span>", :layout => 'application'
            return
        end

        if !current_user || (current_user != project.user && !current_user.modes[:can_edit_projects])
            redirect_to root_path
            return
        end

        if current_user.modes[:can_edit_projects]
            if !params[:project][:name].empty?
                project.name = params[:project][:name]
            end

            if !params[:project][:tag].empty?
                params[:project][:tag].downcase!

                if project.tag.name != params[:project][:tag]
                    if tag = Tag.find_by_name(params[:project][:tag])
                        UsedTag.update_all({ :tag_id => project.tag.id }, ['tag_id = ?', tag.id])
                    end

                    project.tag.name = params[:project][:tag]
                    project.tag.save
                end
            end

            if !params[:project][:user].empty? && project.user.name != params[:project][:user]
                if !(user = User.find_by_name(params[:project][:user]))
                    flash.now[:error] = "The user chosen as owner doesn't exist."
                    self.edit; render 'edit';
                    return
                end

                project.user = user
            end
        end

        if !params[:project][:language].empty?
            project.language = params[:project][:language]
        end

        if !params[:project][:status].empty?
            project.status = params[:project][:status]
        end

        if !params[:project][:page].empty?
            params[:project][:page].gsub!("\r", '')
            project.page = params[:project][:page]
        end

        project.save

        redirect_to "/projects/#{project.name}"
    end

    def delete
        project = Project.find(params[:id]) rescue nil

        if project
            project.tag.type = 'normal'
            project.tag.save

            Project.delete(project.id)
        end
        
        redirect_to root_path
    end
end
