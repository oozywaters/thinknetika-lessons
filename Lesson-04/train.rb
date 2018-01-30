class Train
  attr_reader :speed, :type, :wagons

  def initialize(number, type = 'passenger')
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @current_station_index = 0
  end

  def accelerate(amount = 30)
    new_speed_value = @speed + amount
    @speed = new_speed_value <= 100 ? new_speed_value : 100
  end

  def brake(amount = 30)
    new_speed_value = @speed - amount
    @speed = new_speed_value >= 0 ? new_speed_value : 0
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if wagon.is_a? Wagon
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon)
  end

  def set_route(route)
    if route.class == Route
      self.current_station.send_train(self) if @route
      @route = route
      go_to_station(0)
    end
  end

  def stations
    @route.stations if @route
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
    go_to_station(@current_station_index + 1)
  end

  def go_to_previous_station
    go_to_station(@current_station_index - 1)
  end

  protected

  # нельзя перемещать вагон более чем на одну станцию вперед/назад
  def go_to_station(index)
    if stations && stations[index] && index >= 0
      self.current_station.send_train(self)
      stations[index].accept_train(self)
      @current_station_index = index
    end
  end
end
