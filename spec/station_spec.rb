# frozen_string_literal: true

require 'rspec'

describe 'Station' do
  require 'faker'
  require_relative '../lib/station'
  require_relative '../lib/train'

  before do
    @station = Station.new(Faker::Lorem.word)

    @trains = []
    10.times do
      @trains.append(
        if rand(0..1).eql?(0)
          Train::Passenger.new(Faker::Number.number(digits: 10))
        else
          Train::Cargo.new(Faker::Number.number(digits: 10))
        end
      )
    end
  end

  context 'Имеет' do
    it 'пустой сетап' do
      station = Station.new
      expect(station.nil?)
      expect(station.name).to eq('')
      expect(station.trains).to eq([])
      expect(station).is_a?(Station)
    end

    it 'название, которое указывается при создании' do
      expected_station_name = Faker::Lorem.word

      expect(Station.new(expected_station_name).name).to eq(expected_station_name)
    end
  end

  context 'Может' do
    it 'принимать поезда (по одному за раз)' do
      expect { @station.arrivale(@trains) }.to raise_error(TypeError)
      expect(@station.trains.size).to eq(0)

      @station.trains.append(@trains.first)
      expect(@station.trains.size).to eq(0)

      @station.arrivale(@trains.first)
      expect(@station.trains.first).to eq(@station.trains.first)
    end

    it 'возвращать список всех поездов на станции, находящихся в текущий момент' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eq(10)
      expect(@station.trains).to eq(@trains)
    end

    it 'возвращать список поездов на станции по типу' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eq(10)
      expect(@station.trains).to eq(@trains)

      expect(@station.trains_on_type.nil?).to eq(false)
      expect(@station.trains_on_type.key?(:passenger)).to eq(true)
      expect(@station.trains_on_type.key?(:cargo)).to eq(true)
      expect(@station.trains_on_type[:passenger].empty?).to eq(false)
      expect(@station.trains_on_type[:cargo].empty?).to eq(false)
    end

    it 'может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции)' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eq(10)

      @station.departure(@trains.first)
      @station.departure(@trains.last)

      expect(@station.trains.size).to eq(8)
    end
  end
end
