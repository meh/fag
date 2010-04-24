# == Schema Information
# Schema version: 8
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  modes      :string(255)     default("--- {}\n\n")
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
    attr_accessible :name
    serialize :modes, Hash

    def self.parse (string, options={})
        result = []

        if options[:tree]
        else
            string.scan(/(("(([^\\"]|\\.)*)")|([^\s]+))/) {|match|
                result.push(match[2] || match[4])
            }
        end

        return result
    end
end
