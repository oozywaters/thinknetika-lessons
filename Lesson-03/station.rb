require './train.rb'

class Station
  attr_reader :trains

  def initialize(station_name = 'Default Station')
    @name = station_name
    @trains = []
  end

  def accept_train(train)
    @trains.push(train) if train.class == Train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def get_trains_by_type
    trains_by_type = {}
    @trains.each do |train|
      train_type = train.type.to_sym
      if trains_by_type[train_type]
        trains_by_type[train_type].push(train)
      else
        trains_by_type[train_type] = [train]
      end
    end
    trains_by_type.each { |key, array| puts "There are #{array.size} trains of '#{key.to_s}' type" }
  end
end

my_station = Station.new
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
my_station.send_train(train5)
my_station.get_trains_by_type
