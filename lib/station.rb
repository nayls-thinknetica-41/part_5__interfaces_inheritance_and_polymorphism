# frozen_string_literal: true

# Station
class Station
  attr_accessor :name

  def initialize(name = '')
    @name = name
    @trains = []
  end

  def trains
    @trains.dup
  end

  def trains_on_type
    trains_on_type = {}

    Train::TYPE.each_value do |type|
      trains_on_type.merge!(type => [])
    end

    @trains.each do |train|
      trains_on_type[train.train_type].append(train)
    end

    trains_on_type
  end

  def arrivale(train)
    case train
    when Train::Cargo, Train::Passenger
      @trains.append(train) if Train::TYPE.value?(train.train_type)
    else
      raise TypeError, "#{train.class} is not valid, need #{Train::Cargo} or #{Train::Passenger}"
    end

    # @trains
  end

  def departure(arg)
    case arg
    when Train::Passenger, Train::Cargo
      index = @trains.find_index(arg)
      @trains.delete_at(index) unless index.nil?
    when Integer
      @trains.delete_at(arg)
    else
      raise TypeError, "#{arg.class} is not valid, need #{Train::Cargo}, #{Train::Passenger} or #{Integer}"
    end

    @trains
  end
end
