class Station
  attr_reader :trains, :name
  @instances = []

  class << self
    def all
      # dup to prevent @instances from modifying
      @instances.dup
    end

    private

    def register_instance(instance)
      @instances << instance
    end
  end

  def initialize(station_name)
    @name = station_name
    @trains = []
    self.class.send :register_instance, self
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
