# frozen_string_literal: true

require_relative '../../lib/cli/config'
require_relative '../../lib/cli/station'
require_relative '../../lib/cli/train'
require_relative '../../lib/cli/route'
require_relative '../../lib/cli/wagon'

# Cli
module Cli
  extend self

  HELP = "Usage:\n" \
         "    train.rb SUBCOMMAND ...\n" \
         "\n" \
         "Control subcommands:\n" \
         "    [q]uit\n" \
         "\n" \
         "Subcommands:\n" \
         "    [s]tation\n" \
         "    [t]rain\n" \
         "    [r]oute\n" \
         "    [w]agon\n" \
         "\n"

  def commands
    @commands
  end

  def commands!(env = nil)
    env.nil? ? printf('$> ') : printf("$(#{env})> ")

    # https://stackoverflow.com/questions/6965885/ruby-readline-fails-if-process-started-with-arguments
    cmd = $stdin.gets
    if cmd.nil?
      cmd = ''
      printf "\n"
    else
      cmd.strip!
    end

    @commands = cmd
  end

  def commands_not_found
    puts "Commands \"#{commands}\" not found\n\n"
  end

  def clear_terminal
    if Config.terminal_clear
      # :nocov:
      Gem.win_platform? ? (system 'cls') : (system 'clear')
      # :nocov:
    end
  end

  def help(error: false)
    clear_terminal

    commands_not_found if error

    puts HELP

    control
  end

  def control
    if Config.control
      commands!

      case commands
      when 'q', 'quit'
        exit 0
      when 's', 'station'
        Cli::Station.help
      when 't', 'train'
        Cli::Train.help
      when 'r', 'route'
        Cli::Route.help
      when 'w', 'wagon'
        Cli::Wagon.help
      else
        help(error: true)
      end
    end
  end
end
