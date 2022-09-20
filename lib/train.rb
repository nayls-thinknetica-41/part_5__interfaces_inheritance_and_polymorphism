# frozen_string_literal: true

module Train
  TYPE = {
    CARGO: :cargo,
    PASSENGER: :passenger
  }.freeze

  # Train::Base
  class Base
    attr_accessor :number, :speed
    attr_reader :route, :train_type

    def initialize(number, train_type)
      raise 'Cannot initialize an abstract Train class' if instance_of?(Base)

      @number = number
      @wagons = []
      @speed = 0
      @route = { previous: nil, current: nil, routes_list: [] }
      @train_type = train_type
    end

    def wagons
      @wagons.dup
    end

    def stopped?
      @speed.eql?(0)
    end

    def attach(wagon)
      @wagons.append(wagon) if stopped? &&
                               suitable_wagon?(wagon) &&
                               !@wagons.include?(wagon)
    end

    def unpin(wagon)
      @wagons.delete(wagon) if stopped? &&
                               suitable_wagon?(wagon) &&
                               @wagons.include?(wagon)
    end

    def status
      raise ArgumentError, 'route not initialize' if @route.nil? || @route[:routes_list].empty?

      cur_index = @route[:routes_list].find_index(@route[:current])

      {
        previous: @route[:previous],
        current: @route[:current],
        next: (
          @route[:routes_list][cur_index + 1] unless @route[:routes_list][cur_index + 1].nil?
        )
      }
    end

    def route=(route)
      return unless @route[:routes_list].empty?

      @route[:previous] = nil
      @route[:current] = route.routes.first unless route.routes.first.nil?
      @route[:routes_list] = route.routes
    end

    def forward
      return self if @route[:routes_list].empty?

      cur_index = @route[:routes_list].find_index(@route[:current])
      return self if @route[:routes_list][cur_index + 1].nil?

      @route[:previous] = @route[:current]
      @route[:current] = @route[:routes_list][cur_index + 1]

      self
    end

    def backward
      return self if @route[:routes_list].empty?

      return self if @route[:current].eql?(@route[:routes_list].first)

      cur_index = @route[:routes_list].find_index(@route[:current])

      @route[:current] = @route[:previous]
      @route[:previous] = if @route[:previous].eql?(@route[:routes_list].first)
                            nil
                          else
                            @route[:routes_list][cur_index - 2]
                          end

      self
    end

    protected

    def suitable_wagon?(wagon)
      return true if train_type.eql?(TYPE[:CARGO]) && wagon.wagon_type.eql?(Wagon::TYPE[:CARGO])
      return true if train_type.eql?(TYPE[:PASSENGER]) && wagon.wagon_type.eql?(Wagon::TYPE[:PASSENGER])

      false
    end
  end
end

require_relative 'train/cargo'
require_relative 'train/passenger'
