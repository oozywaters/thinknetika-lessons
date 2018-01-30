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
    puts 'Routes Menu'
    puts '1) Add route'
    puts '2) Edit routes' unless @routes.empty?
    puts '0) Back to Main Menu'
    choice = gets.chomp.to_i
    case choice
      when 0 then display_main_menu
      when 1 then create_route
      when 2 then display_edit_routes_menu
      else
        puts 'There is no such option'
        display_route_menu
    end
  end

  def create_route
    puts 'Select starting station:'
    starting_station = choose_station
    puts 'Select ending station:'
    rest_of_stations = @stations.reject { |item| item == starting_station }
    ending_station = choose_station(rest_of_stations)
    @routes << Route.new(starting_station, ending_station)
    puts "Route '#{starting_station.name} - #{ending_station.name}' was created."
    display_route_menu
  end

  def choose_route(routes = @routes)
    unless routes.empty?
      routes.each_with_index do |item, index|
        puts "#{index}) #{item.name}"
      end
      selected_route = routes[gets.chomp.to_i]
      if !selected_route
        puts 'There is no such route. Please, try again'
        choose_route(routes)
      else
        selected_route
      end
    end
  end

  def choose_station(stations = @stations)
    unless stations.empty?
      stations.each_with_index { |item, index| puts "#{index}) #{item.name}" }
      selected_station = stations[gets.chomp.to_i]
      if !selected_station
        puts 'There is no such station. Please, try again.'
        choose_station(stations)
      else
        selected_station
      end
    end
  end

  def display_edit_routes_menu
    puts 'Select route to edit'
    selected_route = choose_route
    puts 'Select option:'
    puts '1) Add station'
    puts '2) Remove station'
    choice = gets.chomp.to_i
    case choice
      when 1 then add_stations_to_route(selected_route)
      when 2 then remove_stations_from_route(selected_route)
      else
        display_route_menu
    end
  end

  def add_stations_to_route(route)
    stations_to_add = @stations - route.stations
    if stations_to_add.empty?
      puts 'There are no stations to add. Please, create one.'
    else
      selected_station = choose_station(stations_to_add)
      route.add_station(selected_station)
      puts "Station #{selected_station.name} was added to '#{route.name}' route"
    end
    display_route_menu
  end

  def remove_stations_from_route(route)
    if route.way_stations.empty?
      puts 'There are no routes to remove.'
      display_edit_routes_menu
    else
      selected_station = choose_station(route.way_stations)
      route.remove_station(selected_station)
      puts "Station #{selected_station.name} was removed from '#{route.name}' route"
      display_route_menu
    end
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
