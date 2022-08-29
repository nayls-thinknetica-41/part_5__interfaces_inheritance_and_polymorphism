# frozen_string_literal: true

module Wagon
  # Wagon::Passenger
  class Passenger < Wagon::Base
    def initialize(wagon_type = TYPE[:PASSENGER])
      super(wagon_type)
    end
  end
end
