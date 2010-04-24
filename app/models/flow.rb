# == Schema Information
# Schema version: 8
#
# Table name: flows
#
#  id         :integer         not null, primary key
#  closed     :boolean
#  title      :string(255)
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

class Flow < ActiveRecord::Base
    attr_accessible :closed, :title

    has_many :drops,     :autosave => true
    has_many :used_tags, :autosave => true

    def add_tags (text)
        Tag.parse(text).each {|tag|
            self.used_tags << Tag.new(:name => tag)
        }
    end
end
