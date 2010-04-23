class CreateCodes < ActiveRecord::Migration
    def self.up
        create_table :codes do |t|
            t.string :language
            t.text   :content

            t.references :user, :default => nil
            t.string     :name, :default => nil

            t.timestamps
        end
    end

    def self.down
        drop_table :codes
    end
end
