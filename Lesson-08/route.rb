require_relative 'validation'

# Route Class represents train's route
class Route
  include Validation

  attr_reader :stations

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

  protected

  def validate!
    @stations.each_with_index do |item, index|
      next if item.is_a?(Station)
      raise "The station ##{index + 1} is not an object of Station class"
    end
    true
  end
end
