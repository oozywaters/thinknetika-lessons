class Station
  attr_reader :trains, :name

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(station_name)
    @name = station_name
    @trains = []
    @@instances += [self]
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
