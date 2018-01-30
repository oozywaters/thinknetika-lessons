require './route.rb'

class Train
  attr_reader :speed, :type, :wagons_qty

  def initialize(number, type = 'passenger', wagons_qty = 0)
    @number = number
    @type = type
    @wagons_qty = wagons_qty
    @speed = 0
    @current_station_index = 0
  end

  def accelerate(amount = 30)
    new_speed_value = @speed + amount
    @speed = new_speed_value <= 100 ? new_speed_value : 100
  end

  def brake(amount = 30)
    new_speed_value = @speed - amount
    @speed = new_speed_value <= 0 ? new_speed_value : 0
  end

  def stop
    self.speed = 0
  end

  def add_wagon
    @wagons_qty += 1 if speed.zero?
  end

  def remove_wagon
    @wagons_qty -= 1 if speed.zero? && wagons_qty > 0
  end

  def set_route(route)
    if route.class == Route
      @route = route
    end
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @route && @current_station_index != 0
  end

  def next_station
    @route.stations[@current_station_index + 1] if @route
  end

  def current_station
    @route.stations[@current_station_index] if @route
  end

  def go_to_next_station
    @current_station_index += 1 if @route && @current_station_index != @route.stations.size - 1
  end

  def go_to_previous_station
    @current_station_index -= 1 if @route && @current_station_index != 0
  end
end
