# frozen_string_literal: true

require 'rspec'

require_relative '../../spec/utils/io_test_helpers'
require_relative '../../lib/cli/config'
require_relative '../../lib/cli/route'

describe 'Cli::Route' do
  before do
    Config.terminal_clear = false
  end

  context '.help' do
    before do
      Config.control = false
    end

    after do
      Config.control = false
    end

    it 'выводит help' do
      expect { Cli::Route.help }
        .to output(Cli::Route::HELP).to_stdout
    end
  end
end
