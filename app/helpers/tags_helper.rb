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

module TagsHelper
    def self.output (what, *args)
        TagsHelper.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def self.output_link (tag, template='<a href="#{url}" class="float #{type}">#{name} (#{length})</a>')
        if tag.is_a?(UsedTag)
            tag = tag.tag
        end

        type   = tag.type
        url    = "/tags/#{ApplicationHelper.escape tag.name}"
        name   = ERB::Util.h tag.name
        length = tag.length rescue 0

        templatify(template, binding)
    end

    def self.get_tags (flow)
        result = String.new

        UsedTag.find(:all, :conditions => ['flow_id = ?', flow.id], :include => :tag).each {|tag|
            result << " \"#{tag.name}\""
        }

        return result[1, result.length]
    end
end
