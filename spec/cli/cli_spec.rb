# frozen_string_literal: true

require 'rspec'

require_relative '../../spec/utils/io_test_helpers'
require_relative '../../lib/cli/config'
require_relative '../../lib/cli/cli'

describe 'Cli' do
  before do
    Config.terminal_clear = false
    Config.control = true
  end

  after do
    Config.terminal_clear = false
    Config.control = true
  end

  context '.commands' do
    it 'значение @commands по умолчанию пустое' do
      expect(Cli.commands).to eql(nil)
    end

    it 'значение @commands нельзя изменить через Setter' do
      expect { Cli.commands = '' }.to raise_error(NoMethodError)
      expect(Cli.commands).to eql(nil)
    end
  end

  context '.commands!' do
    it '@commands равна "" если не ввести команду' do
      Utils.simulate_stdin("\n") { Cli.commands! }
      expect(Cli.commands).to eql('')
    end

    it 'значение @commands изменяется на "test"' do
      Utils.simulate_stdin('test') { Cli.commands! }
      expect(Cli.commands).to eql('test')
    end
  end

  context '.commands_not_found' do
    it 'возвращает что команда "" не найдена' do
      expect { Cli.commands_not_found }
        .to output("Commands \"#{Cli.commands}\" not found\n\n").to_stdout
    end

    it 'возвращает что команда "test" не найдена' do
      expect { Utils.simulate_stdin('test') { Cli.commands! } }
        .to output('$> ').to_stdout

      expect { Cli.commands_not_found }
        .to output("Commands \"test\" not found\n\n").to_stdout
    end
  end

  context '.help' do
    it 'выводит help' do
      Config.control = false

      expect { Cli.help }
        .to output(Cli::HELP).to_stdout
    end
  end

  context '.contol' do
    context 'выйти из приложения' do
      it 'с помощью короткой команды "q"' do
        expect do
          Utils.simulate_stdin('q') { Cli.help }
        end.to raise_error(SystemExit)
      end

      it 'с помощью длинной команды "quit"' do
        expect do
          Utils.simulate_stdin('quit') { Cli.help }
        end.to raise_error(SystemExit)
      end
    end

    context 'перейти в меню - station' do
      it 'с помощью короткой команды "s"' do
        expect do
          Utils.simulate_stdin('s', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end

      it 'с помощью длинной команды "station"' do
        expect do
          Utils.simulate_stdin('station', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end
    end

    context 'перейти в меню - train' do
      it 'с помощью короткой команды "t"' do
        expect do
          Utils.simulate_stdin('t', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end

      it 'с помощью длинной команды "train"' do
        expect do
          Utils.simulate_stdin('train', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end
    end

    context 'перейти в меню - route' do
      it 'с помощью короткой команды "r"' do
        expect do
          Utils.simulate_stdin('r', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end

      it 'с помощью длинной команды "route"' do
        expect do
          Utils.simulate_stdin('route', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end
    end

    context 'перейти в меню - wagon' do
      it 'с помощью короткой команды "w"' do
        expect do
          Utils.simulate_stdin('w', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end

      it 'с помощью длинной команды "wagon"' do
        expect do
          Utils.simulate_stdin('wagon', 'q') { Cli.help }
        end.to raise_error(SystemExit)
      end
    end
  end
end
