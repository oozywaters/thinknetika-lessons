require './train.rb'

class Station
  attr_reader :trains, :name

  def initialize(station_name)
    @name = station_name
    @trains = []
  end

  def accept_train(train)
    @trains.push(train) if train.class == Train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end

my_station = Station.new('My Station')
train1 = Train.new('1', 'passenger')
train2 = Train.new('2', 'passenger')
train3 = Train.new('3', 'cargo')
train4 = Train.new('4', 'other_type')
train5 = Train.new('5', 'other_type')
my_station.accept_train(train1)
my_station.accept_train(train2)
my_station.accept_train(train3)
my_station.accept_train(train4)
my_station.accept_train(train5)
my_station.send_train(train2)
trains_qty = my_station.get_trains_by_type('passenger').length
puts "There are #{trains_qty} trains of 'passenger' type"
