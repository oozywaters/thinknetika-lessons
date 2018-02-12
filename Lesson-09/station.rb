require_relative 'validation'

# Stations accept and send trains
class Station
  include Validation

  NAME_FORMAT = /^[\S0-9a-z]+$/i

  attr_reader :trains, :name
  validate :name, :presence
  validate :name, :format, NAME_FORMAT

  # rubocop: disable Style/ClassVars
  @@stations = []
  # rubocop: enable Style/ClassVars

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
end
