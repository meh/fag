class CreateFloats < ActiveRecord::Migration
    def self.up
        create_table :floats do |t|
            t.string :name
            t.string :modes, :default => {}.to_yaml

            t.timestamps
        end
    end

    def self.down
        drop_table :floats
    end
end
