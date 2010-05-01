class CreateFlows < ActiveRecord::Migration
    def self.up
        create_table :flows do |t|
            t.boolean :stopped, :default => false

            t.string :title

            t.timestamps
        end
    end

    def self.down
        drop_table :flows
    end
end
