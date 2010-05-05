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

class CreateUsers < ActiveRecord::Migration
    def self.up
        create_table :users do |t|
            t.string :name
            t.string :email, :default => ''
            t.string :password

            t.text :stuff, :default => String.new

            t.text :modes, :default => { :priority_cap => 1000 }.to_yaml

            t.string :theme, :default => 'default'
            t.text   :home_expression

            t.string :remember_token

            t.timestamps
        end

        add_index :users, :name, :unique => true
        add_index :users, :remember_token
    end

    def self.down
        remove_index :users, :name
        remove_index :users, :remember_token

        drop_table :users
    end
end
