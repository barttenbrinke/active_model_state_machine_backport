# ActiveModel::StateMachine backport

Tested on Rails 2.3.2.

## Generate a migration

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

## Write tests for it

    class TrafficLightTest < ActiveSupport::TestCase
      should "correctly act as a state machine" do
        light = TrafficLight.new

        assert_equal :red, light.current_state
        assert light.change_color!
        assert_equal :green, light.current_state
        assert light.change_color!
        assert_equal :yellow, light.current_state
        assert light.change_color!
        assert_equal "Welcome to Worcester. $1.25, sir.", light.tollbooth_willie
      end
    end

## Start using it

    class TrafficLight < ActiveRecord::Base
      include ActiveModel::StateMachine

      attr_accessor :tollbooth_willie

      state_machine do
        state :red
        state :green
        state :yellow

        event :change_color do
          transitions :to => :red,    :from => [:yellow], :on_transition => :catch_runners
          transitions :to => :yellow, :from => [:green]
          transitions :to => :green,  :from => [:red]
        end
      end

      def catch_runners
        self.tollbooth_willie = "Welcome to Worcester. $1.25, sir."
      end
    end

## Persisting the state to the database

    class TrafficLight < ActiveRecord::Base
      include ActiveModel::StateMachine

        # Write state variable
        def write_state(sm, new_state)
          self.state = new_state.to_s
        end

        # Read state variable
        def read_state(sm)
          self.state.blank? ? nil : self.state.to_sym
        end
      end
    end
