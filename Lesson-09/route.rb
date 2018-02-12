require_relative 'station'
require_relative 'validation'

# Route Class represents train's route
class Route
  include Validation

  attr_reader :stations
  validate :stations, :type, [Station]

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
    validate!
  end

  def name
    "#{stations.first.name} - #{stations.last.name}"
  end

  def way_stations
    @stations - [@stations.first, @stations.last]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    # Can't remove staring and ending stations
    @stations.delete(station) if way_stations.include(station)
  end
end
