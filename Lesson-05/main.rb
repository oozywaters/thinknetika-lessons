require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'station'
require_relative 'route'

my_train = PassengerTrain.new('1')
my_train.vendor_name = 'Siemens'
my_wagon = PassengerWagon.new
my_wagon.vendor_name = 'Siemens'
