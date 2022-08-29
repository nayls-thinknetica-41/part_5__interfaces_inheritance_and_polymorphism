# frozen_string_literal: true

module Wagon
  # Wagon::Cargo
  class Cargo < Wagon::Base
    def initialize(wagon_type = TYPE[:CARGO])
      super(wagon_type)
    end
  end
end
