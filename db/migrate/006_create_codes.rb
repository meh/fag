class CreateCodes < ActiveRecord::Migration
    def self.up
        create_table :codes do |t|
            t.string :language
            t.text   :content

            t.reference :user

            t.timestamps
        end
    end

    def self.down
        drop_table :codes
    end
end
