class Route
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
  end

  def add_station(station)
    @stations.insert(-2, station);
  end

  def remove_station(station)
    station_index = @stations.index(station)
    # Can't remove staring and ending stations
    @stations.delete(station) if station_index != @stations.size - 1 && station_index != 0
  end
end
