require_relative 'validation'

# PassengerTrain accepts only passenger wagons
class PassengerTrain < Train
  # include Validation

  def initialize(number)
    super(number, 'passenger')
  end

  def add_wagon(wagon)
    super if wagon.is_a? PassengerWagon
  end
end
