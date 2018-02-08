class CargoWagon < Wagon
  def initialize(volume)
    super('cargo', volume)
  end

  def fill_wagon(volume)
    return if @free_space.zero?
    new_volume = @free_space - volume
    @free_space = new_volume if new_volume >= 0
  end

  def description
    "#{super}, free space: #{free_space}, occupied space: #{occupied_space}"
  end
end
