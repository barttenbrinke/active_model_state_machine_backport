class CreateTrafficLights < ActiveRecord::Migration
  def self.up
    create_table :traffic_lights do |table|
      table.string :state
    end
  end

  def self.down
    drop_table :traffic_lights
  end
end
