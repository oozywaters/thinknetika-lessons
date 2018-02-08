class CargoWagon < Wagon
  def initialize(volume)
    super('cargo', volume)
  end

  def fill_wagon(volume)
    take_space(volume)
  end

  def description
    "#{super}, free space: #{free_space}, occupied space: #{occupied_space}"
  end
end
