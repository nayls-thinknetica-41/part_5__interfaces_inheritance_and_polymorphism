# frozen_string_literal: true

module Cli
  # Wagon
  module Wagon
    extend self

    HELP = "Usage:\n" \
           "    train.rb wagon SUBCOMMAND ...\n" \
           "\n" \
           "Control subcommands:\n" \
           "    [q]uit\n" \
           "    [p]revious\n" \
           "\n" \
           "Subcommands:\n" \
           "    [c]reate\n" \
           "    [g]et\n" \
           "    [e]dit\n" \
           "    [d]elete\n" \
           "\n"

    def help(error: false)
      Cli.clear_terminal

      Cli.commands_not_found if error

      puts HELP

      control
    end

    def control
      if Config.control
        Cli.commands!('wagon')

        case Cli.commands
        when 'q', 'quit'
          exit 0
        when 'p', 'previous'
          Cli.help
        when 'c', 'create'
          help
        when 'g', 'get'
          help
        when 'e', 'edit'
          help
        when 'd', 'delete'
          help
        else
          help(error: true)
        end
      end
    end
  end
end
