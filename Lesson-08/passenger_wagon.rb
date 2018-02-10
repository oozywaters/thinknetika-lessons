# PassengerWagon can be attached to passenger trains
class PassengerWagon < Wagon
  def initialize(seats)
    super(seats, 'passenger')
  end

  def take_space
    super(1)
  end

  def description
    "#{super}, available seats: #{free_space},
 occupied seats: #{occupied_space}"
  end

  alias reserve_seat take_space
end
