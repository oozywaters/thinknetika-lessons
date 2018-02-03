require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'station'
require_relative 'route'

my_train = Train.new('1', 'passenger')
my_train.vendor_name = 'Siemens'
cargo_train = Train.new('2', 'cargo')
cargo_train.vendor_name = 'Siemens'
my_wagon = PassengerWagon.new
my_wagon.vendor_name = 'Siemens'

puts Train.find('1')
puts Train.instances

station1 = Station.new('Vnukovo')
station2 = Station.new('Belorusskaya')
puts Station.all
