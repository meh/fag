class CreateUsedTags < ActiveRecord::Migration
    def self.up
        create_table :used_tags do |t|
            t.reference :tag
            t.reference :flow

            t.timestamps
        end
    end

    def self.down
        drop_table :used_tags
    end
end
