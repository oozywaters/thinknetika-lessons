require_relative 'vendor'
require_relative 'instance_counter'
require_relative 'validation'

# Parent Class for all types of trains
class Train
  include Vendor
  include InstanceCounter
  include Validation

  @hello = 'lskdjf'

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i

  attr_reader :speed, :type, :wagons, :number, :route
  validate :number, :presence
  validate :number, :type, String
  validate :number, :format, NUMBER_FORMAT

  # rubocop: disable Style/ClassVars
  @@trains = {}
  # rubocop: enable Style/ClassVars

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type = 'passenger')
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @current_station_index = 0
    validate!
    @@trains[number] = self
    register_instance
  end

  def name
    "#{type.capitalize} ##{number}"
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
    @wagons << wagon
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon)
  end

  def route=(route)
    return unless route.is_a? Route
    current_station.send_train(self) if @route
    @route = route
    go_to_station(0)
  end

  def stations
    return unless @route
    @route.stations
  end

  def previous_station
    stations[@current_station_index - 1] && @current_station_index != 0
  end

  def next_station
    stations[@current_station_index + 1]
  end

  def current_station
    stations[@current_station_index]
  end

  def go_to_next_station
    go_to_station(@current_station_index + 1)
  end

  def go_to_previous_station
    go_to_station(@current_station_index - 1)
  end

  def each_wagon
    @wagons.each { |wagon| yield wagon } if block_given?
  end

  def description
    "Train ##{@number}, type '#{@type}', wagons: #{@wagons.length}"
  end

  protected

  def go_to_station(index)
    return unless stations && stations[index] && index >= 0
    current_station.send_train(self)
    stations[index].accept_train(self)
    @current_station_index = index
  end

  # def validate!
  #   raise 'Train number cannot be nil' if number.nil?
  #   raise 'Train number has wrong format' if number !~ NUMBER_FORMAT
  #   raise "There is a train ##{number} already" unless @@trains[number].nil?
  #   true
  # end
end
