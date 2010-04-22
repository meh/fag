class CreateCodeComments < ActiveRecord::Migration
    def self.up
        create_table :code_comments do |t|
            t.reference :code

            t.reference :user, :default => nil
            t.string    :name, :default => nil

            t.integer :line
            t.text    :content

            t.timestamps
        end
    end

    def self.down
        drop_table :code_comments
    end
end
