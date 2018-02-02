class Station
  attr_reader :trains, :name

  def initialize(station_name)
    @name = station_name
    @trains = []
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
end
