# == Schema Information
# Schema version: 11
#
# Table name: used_tags
#
#  id         :integer         not null, primary key
#  tag_id     :integer
#  flow_id    :integer
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

class UsedTag < ActiveRecord::Base
    belongs_to :tag
    belongs_to :flow

    def name
        self.tag.name
    end

    def output (what, *args)
        self.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def output_link (template='&quot;<a title="#{length} flows" href="#{url}" class="float #{type}">#{name}</a>&quot;')
        self.tag.output :link, template
    end
end
