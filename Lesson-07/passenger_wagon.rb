class PassengerWagon < Wagon
  def initialize(seats)
    super('passenger', seats)
  end

  def reserve_seat
    @free_space -= 1 unless @free_space.zero?
  end

  def description
    "#{super}, available seats: #{free_space}, occupied seats: #{occupied_space}"
  end
end
