# == Schema Information
# Schema version: 5
#
# Table name: users
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  email          :string(255)     default("")
#  password       :string(255)
#  modes          :string(255)     default("--- {}\n\n")
#  created_at     :datetime
#  updated_at     :datetime
#  remember_token :string(255)
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
    attr_accessor   :passed_password, :passed_password_confirmation
    attr_accessible :name, :email, :password, :passed_password, :passed_password_confirmation

    serialize :modes, Hash

    before_create :create_check

    validates_format_of :email, :with => /[\w\.]+@[\w\.]+\.\w{2,6}/, :on => :update

    def first_check

    end

    def encrypt (value)
        Digest::SHA512.hexdigest(value)
    end

    def create_check
        if self.passed_password.length < 1
            raise "Min password length is 1."
        elsif self.passed_password.length > 50
            raise "Max password length is 50."
        elsif self.passed_password != self.passed_password_confirmation
            raise "Password confirmation doesn't match the given password."
        end

        self.password = self.encrypt(self.passed_password)
    end

    def remember_me!
        self.remember_token = self.encrypt("#{rand}--#{id}")
        save_without_validation
    end

    def password? (value)
        self.encrypt(value) == self.password
    end

    def self.authenticate (name, password)
        if (user = find_by_name(name)) && user.password?(password)
            return user
        end
    end
end
