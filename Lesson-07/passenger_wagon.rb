class PassengerWagon < Wagon
  attr_reader :seats, :available_seats

  def initialize(seats)
    super('passenger')
    @seats = seats
    @available_seats = seats
  end

  def reserve_seat
    @available_seats -= 1 unless @available_seats.zero?
  end

  def occupied_seats
    @seats - @available_seats
  end

  def description
    "Wagon ##{number}, type: #{type}, available seats: #{available_seats}, occupied seats: #{occupied_seats}"
  end
end
