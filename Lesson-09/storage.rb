require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'Station'

# Data Storage
class Storage
  attr_reader :stations, :routes, :trains, :wagons

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
  end

  def seed
    seed_stations
    seed_routes
    seed_trains
  end

  def seed_stations
    @stations << Station.new('Vnukovo')
    @stations << Station.new('Belorusskaya')
  end

  def seed_trains
    train1 = PassengerTrain.new('123-12')
    train2 = CargoTrain.new('154-53')
    wagon1 = PassengerWagon.new(24)
    wagon2 = CargoWagon.new(123.54)
    train1.add_wagon(wagon1)
    train2.add_wagon(wagon2)
    train1.route = @routes[0]
    train2.route = @routes[1]
    @trains.push(train1, train2)
  end

  def seed_routes
    return if @stations.size < 2
    s1, s2 = @stations
    @routes << Route.new(s1, s2)
    @routes << Route.new(s2, s1)
  end

  def add_station(station)
    @stations << station if station.is_a?(Station)
  end

  def add_route(route)
    @routes << route if route.is_a?(Route)
  end

  def delete_route(route)
    @routes.delete(route)
  end

  def add_train(train)
    @trains << train
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def stations?
    !@stations.empty?
  end

  def routes?
    !@routes.empty?
  end

  def trains?
    !@trains.empty?
  end

  def wagons?
    !@wagons.empty?
  end
end
