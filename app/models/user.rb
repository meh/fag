# == Schema Information
# Schema version: 9
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)     default("")
#  password        :string(255)
#  stuff           :text            default("")
#  modes           :text            default("--- \n:priority_cap: 1000\n")
#  theme           :string(255)     default("default")
#  home_expression :text
#  remember_token  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
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
    attr_accessible :name, :email, :stuff, :password, :theme, :home_expression

    has_many :subscriptions, :autosave => true, :dependent => :destroy

    serialize :modes, Hash

    def subscribe (flow)
        if !flow
            return
        end

        subscription = Subscription.new
        subscription.flow = flow
        subscription.user = self

        self.subscriptions << subscription

        self.save
    end

    def unsubscribe (flow)
        if !flow
            return
        end

        Subscription.delete_all(['user_id = ? AND flow_id = ?', self.id, flow.id])
    end

    def subscribed? (flow)
        return !Subscription.find(
            :all,
            :conditions => ['flow_id = ? AND user_id = ?', flow.id, self.id],
            :limit => 1
        ).empty?
    end

    def remember_me!
        self.remember_token = User.encrypt("#{rand}--#{id}")
        save_without_validation
    end

    def set_password (password)
        self.password = User.encrypt(password)
    end

    def password? (value)
        User.encrypt(value) == self.password
    end

    def self.encrypt (value)
        Digest::SHA512.hexdigest(value)
    end

    def self.authenticate (name, password)
        if (user = find_by_name(name)) && user.password?(password)
            return user
        end
    end
end
