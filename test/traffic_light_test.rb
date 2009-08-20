require 'test_helper'
# require 'test/unit'
require 'rubygems'
require 'shoulda'

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

