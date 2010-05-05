# == Schema Information
# Schema version: 10
#
# Table name: codes
#
#  id         :integer         not null, primary key
#  private    :boolean
#  language   :string(255)
#  content    :text
#  user_id    :integer
#  name       :string(255)
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

class Code < ActiveRecord::Base
    attr_accessible :private, :language, :content, :name

    belongs_to :user

    def path
        "/codes/#{self.id}" 
    end

    def output (what, *args)
        self.method("output_#{what.to_s}".to_sym).call(*args)
    end

    def output_owner
        "<span class='owner'>#{
            User.output :user, User.get(self)
        }</span>"
    end

    def output_last_code (template='')
        at = self.created_at
        by = User.output :user, User.get(self)

        return templatify(template, binding)
    end

end
