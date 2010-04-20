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

# == Schema Information
# Schema version: 20100420044923
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  password   :string(255)
#

require 'digest/sha2'

class User < ActiveRecord::Base
    attr_accessible :name, :email, :password

    before_save :encrypt_password

    EmailRegex = /^[\w\-.]+@[\w\-.]+\.\w+$/i

    validates_presence_of :name, :email, :password

    validates_length_of :name, :within => 1..50

    validates_length_of :password, :within => 6..50

    validates_length_of     :email, :within => 3..255
    validates_format_of     :email, :with => EmailRegex
    validates_uniqueness_of :email, :case_sensitive => false

    def encrypt_password
        self.password = Digest::SHA512.hexdigest(self.password)
    end

    def password? (value)
        value == self.password
    end

    def self.authenticate (email, password)
        if (user = find_by_email(email)) && user.password?(password)
            return user
        end
    end
end
