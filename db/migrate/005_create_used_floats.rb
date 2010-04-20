class CreateUsedFloats < ActiveRecord::Migration
    def self.up
        create_table :used_floats do |t|
            t.reference :float
            t.reference :flow

            t.timestamps
        end
    end

    def self.down
        drop_table :used_floats
    end
end
