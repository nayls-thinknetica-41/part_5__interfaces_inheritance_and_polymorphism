# frozen_string_literal: true

require_relative 'station'

# Route
class Route
  def initialize(start_station, end_station)
    raise TypeError, "#{[start_station.class, end_station.class]} is not correct" unless
      station?([start_station, end_station])

    @routes = [start_station, end_station]
  end

  def routes
    @routes.dup
  end

  def insert(station)
    raise TypeError, "#{station.class} is not correct" unless station?(station)

    unless @routes.include?(station)
      @routes.insert(@routes.size - 1, station)
    end

    self
  end

  def delete(station)
    raise TypeError, "#{station.class} is not correct" unless station?(station)

    @routes.delete(station) if @routes.size > 2

    self
  end

  private

  def station?(arg)
    case arg
    when Station
      true
    when Array
      return false if arg.empty?

      arg.each do |station|
        return false if station.eql?(arg)
        return false if station.is_a?(Array)

        return false unless station?(station)
      end

      true
    else
      false
    end
  end
end
