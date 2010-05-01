class CreateProjects < ActiveRecord::Migration
    def self.up
        create_table :projects do |t|
            t.string :name
            t.string :language
            t.text   :page

            t.references :user
            t.references :tag

            t.timestamps
        end

        add_index :projects, :name, :unique => true
    end

    def self.down
        remove_index :projects, :name

        drop_table :projects
    end
end
