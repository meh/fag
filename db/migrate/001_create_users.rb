class CreateUsers < ActiveRecord::Migration
    def self.up
        create_table :users do |t|
            t.string :name
            t.string :email, :default => ''
            t.string :password

            t.string :modes, :default => {}.to_yaml

            t.timestamps
        end

        add_column :users, :remember_token, :string

        add_index :users, :name, :unique => true
        add_index :users, :remember_token
    end

    def self.down
        drop_table :users

        remove_index :users, :name
        remove_index :users, :remember_token

        remove_column :users, :remember_token
    end
end
