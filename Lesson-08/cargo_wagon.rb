class CargoWagon < Wagon
  def initialize(volume)
    super('cargo', volume)
  end

  def description
    "#{super}, free space: #{free_space}, occupied space: #{occupied_space}"
  end

  alias fill_wagon take_space
end
