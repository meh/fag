# == Schema Information
# Schema version: 10
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)     default("normal")
#  priority   :integer         default(9001)
#  created_at :datetime
#  updated_at :datetime
#

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

class Tag < ActiveRecord::Base
    set_inheritance_column :ruby_type

    attr_accessible :name, :type
    serialize :modes, Hash

    def self.find_by_flow (flow)
        Tag.find_by_sql(%{
            SELECT tags.*

            FROM tags, used_tags

            WHERE used_tags.flow_id = #{flow.id} AND used_tags.tag_id = tags.id
        })
    end

    def self.parse (string, options={})
        result = []

        if options[:tree]
        else
            string.scan(/(("(([^\\"]|\\.)*)")|([^\s]+?))(,|;|\s|$)/) {|match|
                tag = (match[2] || match[4] || 'undefined').downcase

                if tag.match(/(&&|\|\||!)/)
                    next
                end

                result.push(tag)
            }
        end

        return result.uniq
    end

    def output (what, *args)
        self.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def output_url
        if (name = self.name).match(/\s/)
            name = %{"#{self.name}"}
        end

        return "/ocean/search/#{ApplicationHelper.escape name}"
    end

    def output_link (template='&quot;<a title="#{length} flows" href="#{url}" class="float #{type}">#{name}</a>&quot;')
        type   = ERB::Util.h self.type
        url    = ERB::Util.h self.output :url
        name   = ERB::Util.h self.name
        length = tag.length rescue 0

        templatify(template, binding)
    end
end
