class CreateTags < ActiveRecord::Migration
    def self.up
        create_table :tags do |t|
            t.string :name

            t.string :type, :default => 'normal'

            t.integer :priority, :default => 9001

            t.timestamps
        end

        add_index :tags, :name, :unique => true
    end

    def self.down
        remove_index :tags, :name

        drop_table :tags
    end
end
