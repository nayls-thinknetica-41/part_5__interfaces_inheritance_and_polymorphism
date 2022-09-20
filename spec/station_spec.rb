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
      expect(station.name).to eql('')
      expect(station.trains).to eql([])
      expect(station).is_a?(Station)
    end

    it 'название, которое указывается при создании' do
      expected_station_name = Faker::Lorem.word

      expect(Station.new(expected_station_name).name).to eql(expected_station_name)
    end
  end

  context 'Может' do
    it 'принимать поезда (по одному за раз)' do
      expect { @station.arrivale(@trains) }.to raise_error(TypeError)
      expect(@station.trains.size).to eql(0)

      @station.trains.append(@trains.first)
      expect(@station.trains.size).to eql(0)

      @station.arrivale(@trains.first)
      expect(@station.trains.first).to eql(@station.trains.first)
    end

    it 'возвращать список всех поездов на станции, находящихся в текущий момент' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eql(10)
      expect(@station.trains).to eql(@trains)
    end

    it 'возвращать список поездов на станции по типу' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eql(10)
      expect(@station.trains).to eql(@trains)

      expect(@station.trains_on_type.nil?).to eql(false)
      expect(@station.trains_on_type.key?(:passenger)).to eql(true)
      expect(@station.trains_on_type.key?(:cargo)).to eql(true)
      expect(@station.trains_on_type[:passenger].empty?).to eql(false)
      expect(@station.trains_on_type[:cargo].empty?).to eql(false)
    end

    it 'может отправлять поезда (по одному за раз, при этом,
        поезд удаляется из списка поездов, находящихся на станции)' do
      @trains.each { |train| @station.arrivale(train) }

      expect(@station.trains.size).to eql(10)

      @station.departure(@trains.first)
      @station.departure(@trains.last)
      expect(@station.trains.size).to eql(8)

      @station.departure(1)
      expect(@station.trains.size).to eql(7)

      expect { @station.departure('Train') }.to raise_error(TypeError)
    end
  end
end
