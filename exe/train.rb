#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cli/cli'

begin
  Cli.clear_terminal
  Cli.help
rescue SystemExit, Interrupt
  exit 0
end
