class CreateNews < ActiveRecord::Migration
    def self.up
        create_table :news do |t|
            t.reference :user

            t.string :title
            t.text   :content

            t.timestamps
        end
    end

    def self.down
        drop_table :news
    end
end
