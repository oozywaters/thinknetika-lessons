# CargoTrain Class accepts only cargo wagons
class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end

  def add_wagon(wagon)
    super if wagon.is_a? CargoWagon
  end
end
