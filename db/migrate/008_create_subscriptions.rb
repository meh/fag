class CreateSubscriptions < ActiveRecord::Migration
    def self.up
        create_table :subscriptions do |t|
            t.references :user
            t.references :flow

            t.timestamps
        end

        add_index :subscriptions, [:user_id, :flow_id], :unique => true
    end

    def self.down
        remove_index :subscriptions, [:user_id, :flow_id]

        drop_table :subscriptions
    end
end
