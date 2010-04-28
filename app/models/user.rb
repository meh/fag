# == Schema Information
# Schema version: 9
#
# Table name: users
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  email          :string(255)     default("")
#  password       :string(255)
#  stuff          :text
#  modes          :string(255)     default("--- {}\n\n")
#  remember_token :string(255)
#  created_at     :datetime
#  updated_at     :datetime
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

require 'digest/sha2'

class User < ActiveRecord::Base
    attr_accessible :name, :email, :stuff, :password

    serialize :modes, Hash

    def self.encrypt (value)
        Digest::SHA512.hexdigest(value)
    end

    def set_password (password)
        self.password = User.encrypt(password)
    end

    def remember_me!
        self.remember_token = User.encrypt("#{rand}--#{id}")
        save_without_validation
    end

    def password? (value)
        User.encrypt(value) == self.password
    end

    def self.authenticate (name, password)
        if (user = find_by_name(name)) && user.password?(password)
            return user
        end
    end
end
