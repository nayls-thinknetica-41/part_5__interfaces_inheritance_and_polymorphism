# frozen_string_literal: true

module Wagon
  TYPE = {
    CARGO: :cargo,
    PASSENGER: :passenger
  }.freeze

  # Wagon::Base
  class Base
    attr_reader :wagon_type

    def initialize(wagon_type)
      raise 'Cannot initialize an abstract Wagon class' if instance_of?(Base)

      @wagon_type = wagon_type
    end
  end
end

require_relative 'wagon/cargo'
require_relative 'wagon/passenger'
