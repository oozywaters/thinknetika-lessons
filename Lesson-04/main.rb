require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'station'

class App
  attr_reader :stations, :trains

  def initialize
    @stations = []
    @trains = { cargo: [], passenger: [] }
  end

  def run
    display_main_menu
  end

  private

  def display_station_menu
    puts 'Enter station name'
    station_name = gets.chomp
    if !stations.detect { |item| item.name == station_name }
      stations << Station.new(station_name)
      display_main_menu
    else
      puts 'There is a station with such name already'
      display_station_menu
    end
  end

  def display_train_type_menu
    puts 'Choose a type of train'
    puts '1) Passenger'
    puts '2) Cargo'
    choice = gets.chomp.to_i
    type = ''
    case choice
      when 1
        type = 'passenger'
      when 2
        type = 'cargo'
      else
        puts 'There is no such type fo train.'
        display_train_menu
    end
    display_train_numer_menu(type)
  end

  def display_train_numer_menu(type)
    puts "What's a train number?"
    train_number = gets.chomp
    new_train = type == 'cargo' ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
    @trains[type.to_sym] << new_train
    puts "#{type.capitalize} train ##{train_number} was added"
    display_main_menu
  end

  def display_main_menu
    puts 'What do you want?'
    puts '1) Add Station'
    puts '2) Add Train'
    puts '3) Create a Route'
    puts '0) Exit'
    choice = gets.chomp.to_i
    case choice
      when 1
        display_station_menu
      when 2
        display_train_type_menu
      when 0
        exit
      else
        puts 'There is no such option!'
        display_main_menu
    end
  end

  def exit
    puts 'See ya!!'
  end
end

my_app = App.new
my_app.run
