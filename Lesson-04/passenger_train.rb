class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
  end

  def add_wagon(wagon)
    super if wagon.is_a? PassengerWagon
  end
end
