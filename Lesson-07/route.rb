require_relative 'validation'

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
    @stations.insert(-2, station);
  end

  def remove_station(station)
    station_index = @stations.index(station)
    # Can't remove staring and ending stations
    @stations.delete(station) if station_index != @stations.size - 1 && station_index != 0
  end

  protected

  def validate!
    @stations.each_with_index do |item, index|
      raise "The station ##{index + 1} is not an object of Station class" unless item.is_a? Station
    end
    true
  end
end
