class CreateDrops < ActiveRecord::Migration
    def self.up
        create_table :drops do |t|
            t.references :flow

            t.references :user
            t.string     :name

            t.string :title
            t.text   :content

            t.timestamps
        end
    end

    def self.down
        drop_table :drops
    end
end
