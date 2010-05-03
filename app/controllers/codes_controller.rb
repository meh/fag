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

include ERB::Util

class CodesController < ApplicationController
    attr_accessor :code

    def index
        @title = 'Code.all'

        @codes = Code.find(:all, :limit => 23, :order => 'created_at DESC')
    end

    def show
        @code = Code.find(params[:id])

        @title = "Code [#{SyntaxHighlighter.language(@code.language, true)}]"
    end

    def raw
        render :text => Code.find(params[:id]).content, :content_type => 'text/plain', :layout => false
    end

    def new
        @title = "Code.new"
    end

    def create
        if params[:code][:language].empty? || params[:code][:source].empty?
            flash.now[:error] = 'The language or the source are empty.'
            self.new; render 'new'
            return
        end

        code = Code.new(:language => params[:code][:language], :content => params[:code][:source].gsub("\r", ''))

        if !current_user
            if params[:code][:name].empty?
                params[:code][:name] = 'Anonymous'
            end

            code.name = params[:code][:name]
        else
            code.user = current_user
        end

        code.save

        redirect_to "/codes/#{code.id}"
    end
end
