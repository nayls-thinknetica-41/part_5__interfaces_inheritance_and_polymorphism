# frozen_string_literal: true

# Config
module Config
  extend self

  @terminal_clear = true
  @control        = true

  attr_accessor :terminal_clear, :control
end
