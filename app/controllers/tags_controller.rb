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

class TagsController < ApplicationController
    def new
        @title ='Tag.new'
    end

    def create
        tag = Tag.new(params[:tag])
        tag.save

        redirect_to root_path
    end

    def edit
        if !current_user || !current_user.modes[:can_edit_tags]
            render :text => "<span class='error'>You can't edit tags.</span>", :layout => 'application'
        end

        @tag = Tag.find_by_name(params[:id])

        if @tag
            @title = "Tag.edit :#{@tag.name}"
        end
    end

    def update
        tag = Tag.find(params[:tag][:id])

        if !current_user || !current_user.modes[:can_edit_tags]
            raise "You can't edit tags."
        end

        tag.name     = params[:tag][:name]
        tag.type     = params[:tag][:type]
        tag.priority = params[:tag][:priority]

        tag.save

        redirect_to root_path
    end
end
