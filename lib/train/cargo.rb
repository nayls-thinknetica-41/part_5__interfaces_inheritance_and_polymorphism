# frozen_string_literal: true

module Train
  # Train::Cargo
  class Cargo < Train::Base
    def initialize(number = 0, train_type = TYPE[:CARGO])
      super(number, train_type)
    end

    # protected
    #
    # def suitable_wagon?(wagon)
    #   wagon.is_a?(Wagon::Cargo)
    # end
  end
end
