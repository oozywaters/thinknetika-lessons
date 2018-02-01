require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'

class App
  attr_reader :stations, :trains, :main_menu

  def initialize
    @stations = [Station.new('Vnukovo'), Station.new('Belorusskaya')]
    @routes = [Route.new(@stations[0], @stations[1])]
    @trains = []

    @stations_menu = {
      title: 'Stations Menu',
      items: {
        '1' => {
          name: 'Add Station',
          action: :add_station
        },
        '2' => {
          name: 'Stations List',
          action: :show_stations
        },
        '0' => {
          name: 'Back to Main Menu',
          action: :display_main_menu
        }
      }
    }

    @add_train_menu = {
      title: 'Choose a Type of Train',
      items: {
        '1' => {
          name: 'Passenger',
          action: [:add_train, 'passenger']
        },
        '2' => {
          name: 'Cargo',
          action: [:add_train, 'cargo']
        }
      }
    }

    @trains_menu = {
      title: 'Trains Menu',
      items: {
        '1' => {
          name: 'Add Train',
          action: [:display_menu, @add_train_menu]
        },
        '2' => {
          name: 'Assign Route to Train',
          action: :assign_route_to_train
        },
        '3' => {
          name: 'Add Wagons to Train',
          action: :add_wagons_to_train
        },
        '4' => {
          name: 'Remove Wagons from Train',
          action: :remove_wagons_from_train
        },
        '5' => {
          name: 'Move Train',
          action: :move_train
        },
        '0' => {
          name: 'Back to Main Menu',
          action: :display_main_menu
        },
      },
    }

    @routes_menu = {
      title: 'Routes Menu',
      items: {
        '1' => {
          name: 'Add Route',
          action: :add_route
        },
        '2' => {
          name: 'Edit Route',
          action: :edit_route
        },
        '3' => {
          name: 'Remove Route',
          action: :remove_route
        },
        '0' => {
          name: 'Back to Main Menu',
          action: :display_main_menu
        }
      }
    }

    @main_menu = {
      title: 'Main Menu',
      items: {
        '1' => {
          name: 'Stations',
          action: [:display_menu, @stations_menu]
        },
        '2' => {
          name: 'Trains',
          action: [:display_menu, @trains_menu]
        },
        '3' => {
          name: 'Routes',
          action: [:display_menu, @routes_menu]
        },
        '0' => {
          name: 'Exit',
          action: :exit
        }
      },
    }
  end

  def run
    display_main_menu
  end

  private

  def add_station
    puts 'Enter station name'
    station_name = gets.chomp
    if !stations.detect { |item| item.name == station_name }
      stations << Station.new(station_name)
      puts "Station '#{station_name}' was added"
      display_menu(@stations_menu)
    else
      puts 'There is a station with such name. Please, try again.'
      add_station
    end
  end

  def show_stations
    if stations.empty?
      puts 'There is no stations yet. Please, add one.'
      display_menu(@stations_menu)
    else
      puts 'Select station to view'
      selected_station = choose_station
      puts "#{selected_station.name} station, trains: #{selected_station.trains}"
    end
  end

  def move_train
    if @trains.empty?
      puts 'There are no trains to move. Please, create one.'
    else
      puts 'Select Train to move'
      selected_train = choose_item_from_array(@trains)
      if selected_train.route
        select_train_destination(selected_train)
        puts "#{selected_train.name} train is now at #{selected_train.current_station.name} station"
      else
        puts "#{selected_train.name} train has no assigned route"
      end
    end
    display_menu(@trains_menu)
  end

  def select_train_destination(train)
    puts "Select #{train.name} destination"
    puts '1) Next Station'
    puts '2) Previous Station'
    choice = gets.chomp.to_i
    case choice
      when 1 then train.go_to_next_station
      when 2 then train.go_to_previous_station
      else
        puts 'There is no such option. Please, try again'
        select_train_destination(train)
    end
  end

  def add_train(type)
    puts "Enter Train Number"
    train_number = gets.chomp
    new_train = type == 'cargo' ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
    @trains << new_train
    puts "#{type.capitalize} train ##{train_number} was added"
    display_menu(@trains_menu)
  end

  def assign_route_to_train
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    elsif @routes.empty?
      puts 'There are no routes to assign yet. Please, add one.'
    else
      puts 'Select Train to Assign Route'
      selected_train = choose_item_from_array(@trains)
      puts "Selecte Route to Assign #{selected_train.name} Train"
      selected_route = choose_item_from_array(@routes)
      selected_train.set_route(selected_route)
      puts "#{selected_route.name} Route was successfully Assigned to #{selected_train.name} Train"
    end
    display_menu(@trains_menu)
  end

  def add_wagons_to_train
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      new_wagon = Wagon.new(selected_train.type)
      selected_train.add_wagon(new_wagon)
      puts "#{new_wagon.name.capitalize} wagon was successfully added to #{selected_train.name} train"
    end
    display_menu(@trains_menu)
  end

  def remove_wagons_from_train
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      if selected_train.wagons.empty?
        puts "#{selected_train.name.capitalize} train has no wagons"
      else
        puts 'Select wagon to remove'
        selected_wagon = choose_item_from_array(selected_train.wagons)
        selected_train.remove_wagon(selected_wagon)
        puts "#{selected_wagon.name.capitalize} wagon was successfully removed from #{selected_train.name} train"
      end
    end
    display_menu(@trains_menu)
  end

  def add_route
    if @stations.size < 2
      puts 'There are not enough stations to create a route'
    else
      puts 'Select starting station:'
      starting_station = choose_item_from_array(@stations)
      puts 'Select ending station:'
      rest_of_stations = @stations.reject { |item| item == starting_station }
      ending_station = choose_item_from_array(rest_of_stations)
      @routes << Route.new(starting_station, ending_station)
      puts "Route '#{starting_station.name} - #{ending_station.name}' was created."
    end
    display_menu(@routes_menu)
  end

  def edit_route
    if @routes.empty?
      puts 'There are no routes to edit. Please, create one.'
    else
      puts 'Select route to edit:'
      selected_route = choose_item_from_array(@routes)
      puts route
    end
    display_menu(@routes_menu)
  end

  def remove_route
    if @routes.empty?
      puts 'There are no routes to delete.'
    else
      puts 'Select route to delete:'
      selected_route = choose_item_from_array(@routes)
      @routes.delete(selected_route)
      puts "Route '#{selected_route.name}' was deleted"
    end
    display_menu(@routes_menu)
  end

  def choose_item_from_array(items)
    if items && items.is_a?(Array) && !items.empty?
      items.each_with_index do |item, index|
        puts "#{index + 1}) #{item.name}" if item.class.method_defined? :name
      end
      selected_item = items[gets.chomp.to_i - 1]
      if !selected_item
        puts 'There is no such option. Please, try again.'
        choose_item_from_array(items)
      else
        selected_item
      end
    end
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

  def choose_train(trains = @trains)
    unless trains.empty?
      trains.each_with_index { |item, index| puts "#{index + 1}) #{item.type} ##{item.number}" }
      selected_train = trains[gets.chomp.to_i - 1]
      if !selected_train
        puts 'There is no such train. Please, try again.'
        choose_train
      else
        selected_train
      end
    end
  end

  def display_edit_routes_menu
    puts 'Select route to edit'
    selected_route = choose_item_from_array(@routes)
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
      selected_station = choose_item_from_array(stations_to_add)
      route.add_station(selected_station)
      puts "Station #{selected_station.name} was added to '#{route.name}' route"
    end
    display_menu(@routes_menu)
  end

  def remove_stations_from_route(route)
    if route.way_stations.empty?
      puts 'There are no routes to remove.'
      display_edit_routes_menu
    else
      selected_station = choose_item_from_array(route.way_stations)
      route.remove_station(selected_station)
      puts "Station #{selected_station.name} was removed from '#{route.name}' route"
      display_route_menu
    end
  end

  def display_menu(menu)
    if menu
      puts menu[:title]
      menu[:items].each { |item| puts "#{item[0]}) #{item[1][:name]}" }
    end
    menu_item = menu[:items][gets.chomp]
    if menu_item && menu_item[:action]
      send(*menu_item[:action])
    else
      puts 'There is no such option. Please, try again.'
      display_menu(menu)
    end
  end

  def display_main_menu
    display_menu(@main_menu)
  end

  def exit
    puts 'See ya!!'
  end
end

my_app = App.new
my_app.run