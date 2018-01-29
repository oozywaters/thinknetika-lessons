require './route.rb'

def generate_random_string(length = 5)
  key = ''
  source = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ['_', '-', '.']
  length.times { key += source[rand(source.size)].to_s }
  key
end

class Train
  attr_accessor :speed
  attr_reader :type
  attr_reader :wagons_qty
  attr_reader :previous_station
  attr_reader :current_station
  attr_reader :next_station

  def initialize(number = generate_random_string, type = 'passenger', wagons_qty = 0)
    @number = number
    @type = type
    @wagons_qty = wagons_qty
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def show_wagons_qty
    puts "Now Train ##{@number} has #{@wagons_qty} wagons"
  end

  def add_wagon
    if speed.zero?
      @wagons_qty += 1
      show_wagons_qty
    end
  end

  def remove_wagon
    if speed.zero? && wagons_qty > 0 && @type != 'passenger'
      @wagons_qty -= 1
      show_wagons_qty
    end
  end

  def set_route(route)
    if route.class == Route
      @route = route
      @current_station = route.stations.first
      @next_station = route.stations[1]
    end
  end

  def go_to_next_station
    if @route
      stations = @route.stations
      current_station_index = stations.index(@current_station)
      if current_station_index != stations.size - 1
        @previous_station = @current_station
        @current_station = stations[current_station_index + 1]
        @next_station = stations[current_station_index + 2]
      else
        puts "You've reached the end of route!"
      end
    else
      puts "Train #{@number} has no route yet!"
    end
  end

  def go_to_previous_station
    if @route
      stations = @route.stations
      current_station_index = stations.index(@current_station)
      if current_station_index != 0
        @next_station = @current_station
        @current_station = stations[current_station_index - 1]
        @previous_station = stations[current_station_index - 2]
      else
        puts "You've reached the start of route!"
      end
    else
      puts "Train #{@number} has no route yet!"
    end
  end
end
