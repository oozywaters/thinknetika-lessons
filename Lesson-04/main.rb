require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'

class App
  attr_reader :stations, :trains

  def initialize
    @stations = [Station.new('Vnukovo'), Station.new('Belorusskaya')]
    @routes = []
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
      puts "Station '#{station_name}' was added"
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
        puts 'There is no such type of train.'
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

  def display_route_menu
    puts 'Routes'
    puts '1) Add route'
    puts '2) Edit routes' unless @routes.empty?
    puts '0) Back to Main Menu'
    choice = gets.chomp.to_i
    case choice
      when 0 then display_main_menu
      when 1 then display_add_route_menu
      when 2
        if @routes.empty?
          puts 'There are no routes to edit yet'
          display_route_menu
        else
          display_edit_routes_menu
        end
      else
        puts 'There is no such option'
        display_route_menu
    end
  end

  def display_add_route_menu
    puts 'Select starting station'
    @stations.each_with_index { |item, index| puts "#{index}) #{item.name}" }
    starting_station = @stations[gets.chomp.to_i]
    if starting_station
      puts 'Select ending station'
      ending_stations = @stations.reject(starting_station)
      ending_stations.each_with_index { |item, index| puts "#{index}) #{item.name}" }
      end_station = ending_stations[gets.chomp.to_i]
      return display_add_route_menu unless end_station
      @routes << Route.new(starting_station, end_station)
      display_route_menu
    else
      puts 'There is no such station'
      display_add_route_menu
    end
  end

  def display_routes_list
    @routes.each_with_index do |item, index|
      stations = item.stations.collect { |station| station.name }
      puts "#{index}) #{stations.join(', ')}"
    end
  end

  def display_edit_routes_menu
    puts 'Select route to edit'
    display_routes_list
  end

  def display_main_menu
    puts 'What do you want?'
    puts '1) Add Station'
    puts '2) Add Train'
    puts '3) Routes menu'
    puts '0) Exit'
    choice = gets.chomp.to_i
    case choice
      when 1 then display_station_menu
      when 2 then display_train_type_menu
      when 3
        if @stations.size >= 2
          display_route_menu
        else
          puts 'Please, add at least 2 stations first'
          display_main_menu
        end
      when 0 then exit
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
