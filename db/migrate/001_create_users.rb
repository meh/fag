class CreateUsers < ActiveRecord::Migration
    def self.up
        create_table :users do |t|
            t.string :name
            t.string :email, :default => ''
            t.string :password

            t.text :stuff

            t.string :modes, :default => {}.to_yaml

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
