# frozen_string_literal: true

require 'rspec'

describe 'Train' do
  require 'faker'
  require_relative '../lib/route'
  require_relative '../lib/station'
  require_relative '../lib/train'
  require_relative '../lib/wagon'

  before do
    @train = if rand(0..1).eql?(0)
               Train::Passenger.new(
                 rand(0..1).eql?(0) ? Train::TYPE[:CARGO] : Train::TYPE[:PASSENGER],
                 Faker::Number.number(digits: 10)
               )
             else
               Train::Cargo.new(
                 rand(0..1).eql?(0) ? Train::TYPE[:CARGO] : Train::TYPE[:PASSENGER],
                 Faker::Number.number(digits: 10)
               )
             end

    @train_passenger = Train::Passenger.new(Train::TYPE[:PASSENGER], Faker::Number.number(digits: 10))
    @train_cargo = Train::Cargo.new(Train::TYPE[:CARGO], Faker::Number.number(digits: 10))

    @st1 = Station.new(Faker::Lorem.word)
    @st2 = Station.new(Faker::Lorem.word)
    @st3 = Station.new(Faker::Lorem.word)

    @rt1 = Route.new(@st1, @st3)
    @rt2 = Route.new(@st1, @st3)

    @wagon_cargo = Wagon::Cargo.new
    @wagon_passenger = Wagon::Passenger.new
  end

  context 'нельзя' do
    it 'создать объект класса Train' do
      expect { Train::Base.new(0, Train::TYPE[:CARGO]) }.to raise_error(RuntimeError)
    end
  end

  context 'Имеет' do
    it 'номер и указывается при создании экземпляра класса пассажирского поезда' do
      train_number = Faker::Number.number(digits: 10)

      train = Train::Passenger.new(train_number)

      expect(train.class).is_a?(Train::Passenger)
      expect(train.number).to eq(train_number)
      expect(train.wagons).to eq([])
      expect(train.speed).to eq(0)
      expect(train.route).to eq({ previous: nil, current: nil, next: nil, routes_list: [] })
    end

    it 'номер (произвольная строка) указывается при создании экземпляра класса грузового поезда' do
      train_number = Faker::Number.number(digits: 10)

      train = Train::Cargo.new(train_number)

      expect(train.class).is_a?(Train::Cargo)
      expect(train.number).to eq(train_number)
      expect(train.wagons).to eq([])
      expect(train.speed).to eq(0)
      expect(train.route).to eq({ previous: nil, current: nil, next: nil, routes_list: [] })
    end
  end

  context 'Может' do
    it 'набирать скорость' do
      expect(@train.speed).to eql(0)

      @train.speed = 15
      expect(@train.speed).to eql(15)
    end

    it 'возвращать текущую скорость' do
      @train.speed = 10
      expect(@train.speed).to eql(10)
    end

    it 'тормозить (сбрасываь скорость до нуля)' do
      @train.speed = 10
      expect(@train.speed).to eql(10)

      @train.speed = 0
      expect(@train.speed).to eql(0)
    end

    it 'возвращать количество вагонов' do
      expect(@train.wagons.size).to eql(0)
      expect(@train.wagons.class).to eql(Array)
    end

    context 'грузовой поезд' do
      before do
        @train = Train::Cargo.new(Faker::Number.number(digits: 10))

        @wagon_cargo1 = Wagon::Cargo.new
        @wagon_cargo2 = Wagon::Cargo.new
        @wagon_cargo3 = Wagon::Cargo.new
      end

      it 'прицеплять/отцеплять вагоны только если поезд не движется' do
        cur_wagon_size = @train.wagons.size
        expect(@train.wagons.size).to eql(0)

        @train.speed = 120
        expect(@train.stopped?).to eql(false)

        @train.attach(@wagon_cargo)
        expect(@train.wagons.size).not_to eql(cur_wagon_size + 1)

        @train.unpin(@wagon_cargo)
        expect(@train.wagons.size).not_to eql(cur_wagon_size - 1)

        @train.speed = 0
        expect(@train.stopped?).to eql(true)

        @train.attach(@wagon_cargo)
        expect(@train.wagons.size).to eql(cur_wagon_size + 1)

        @train.unpin(@wagon_cargo)
        expect(@train.wagons.size).to eql(cur_wagon_size)
      end

      it 'прицеплять/отцеплять вагоны только своего типа' do
        expect(@train.stopped?).to eql(true)

        @train.attach(@wagon_cargo)
        expect(@train.wagons.size).to eql(1)

        @train.attach(@wagon_passenger)
        expect(@train.wagons.size).to eql(1)
      end
    end

    context 'пассажирский поезд' do
      before do
        @train = Train::Passenger.new(Faker::Number.number(digits: 10))

        @wagon_passenger1 = Wagon::Passenger.new
        @wagon_passenger2 = Wagon::Passenger.new
        @wagon_passenger3 = Wagon::Passenger.new
      end

      it 'прицеплять/отцеплять вагоны только если поезд не движется' do
        cur_wagon_size = @train.wagons.size
        expect(@train.wagons.size).to eql(0)

        @train.speed = 120
        expect(@train.stopped?).to eql(false)

        @train.attach(@wagon_passenger)
        expect(@train.wagons.size).not_to eql(cur_wagon_size + 1)

        @train.unpin(@wagon_passenger)
        expect(@train.wagons.size).not_to eql(cur_wagon_size - 1)

        @train.speed = 0
        expect(@train.stopped?).to eql(true)

        @train.attach(@wagon_passenger)
        expect(@train.wagons.size).to eql(cur_wagon_size + 1)

        @train.unpin(@wagon_passenger)
        expect(@train.wagons.size).to eql(cur_wagon_size)
      end

      it 'прицеплять/отцеплять вагоны только своего типа' do
        expect(@train.stopped?).to eql(true)

        @train.attach(@wagon_cargo)
        expect(@train.wagons.size).to eql(0)

        @train.attach(@wagon_passenger)
        expect(@train.wagons.size).to eql(1)
      end
    end

    it 'принимать маршрут следования' do
      @train.route = @rt1
    end

    it 'при назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте' do
      expect(@train.route[:current].nil?).to eql(true)
      expect(@train.route[:routes_list].empty?).to eql(true)

      @train.route = @rt1
      expect(@train.route[:current].nil?).to eql(false)
      expect(@train.route[:routes_list].empty?).to eql(false)
    end

    it 'перемещаться между станциями, указанными в маршруте вперед на 1 станцию за раз' do
      @train.route = @rt1

      expect(@train.route[:previous].nil?).to eql(true)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])
    end

    it 'перемещаться между станциями, указанными в маршруте назад на 1 станцию за раз' do
      @train.route = @rt1

      @train.forward
      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.backward

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.backward

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])
    end

    it 'возвращать предыдущую, текущую, следующую станцию на основе маршрута' do
      @train.route = @rt1

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
    end
  end
end
