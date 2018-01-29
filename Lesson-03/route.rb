class Route
  attr_reader :stations

  def initialize(starting_station = 'Starting Station', end_station = 'End Station')
    @starting_station = starting_station
    @end_station = end_station
    @stations = [starting_station, end_station]
  end

  def add_station(station)
    @stations.insert(-2, station);
  end

  def remove_station(station)
    @stations.delete(station) if station != @starting_station && station != @end_station
  end
end
