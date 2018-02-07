require_relative 'validation'

class Station
  include Validation

  attr_reader :trains, :name
  @@stations = []

  NAME_FORMAT = /^[\S0-9a-z]+$/i

  def self.all
    # dup to prevent @instances from modifying
    @@stations.dup
  end

  def initialize(station_name)
    @name = station_name
    @trains = []
    validate!
    @@stations << self
  end

  def accept_train(train)
    @trains.push(train)
  end

  def send_train(train)
    @trains.delete(train)
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_train
    @trains.each { |train| yield train } if block_given?
  end

  protected

  def validate!
    raise 'Station name cannot be nil.' if @name.nil?
    raise 'Station name has wrong format.' if @name !~ NAME_FORMAT
    raise 'There is a station with such name.' if @@stations.detect { |item| item.name == @name }
    true
  end
end
