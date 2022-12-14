# frozen_string_literal: true

module Train
  # Train::Passenger
  class Passenger < Train::Base
    def initialize(number = 0, train_type = TYPE[:PASSENGER])
      super(number, train_type)
    end
  end
end
