class CargoWagon < Wagon
  attr_reader :volume, :free_space

  def initialize(volume)
    super('cargo')
    @volume = volume
    @free_space = volume
  end

  def fill_wagon(volume)
    return if @free_space.zero?
    new_volume = @free_space - volume
    @free_space = new_volume if new_volume >= 0
  end

  def occupied_space
    @volume - @free_space
  end

  def description
    "Wagon ##{number}, type: #{type}, free space: #{free_space}, occupied space: #{occupied_space}"
  end
end
