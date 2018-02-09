require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'station'
require_relative 'route'

class App
  attr_reader :trains

  STATIONS_MENU = {
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

  ADD_TRAIN_MENU = {
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

  EDIT_TRAIN_MENU = {
    title: 'Edit train',
    items: {
      '1' => {
        name: 'Assign Route to Train',
        action: :assign_route_to_train
      },
      '2' => {
        name: 'Add Wagons to Train',
        action: :add_wagons_to_train
      },
      '3' => {
        name: 'Remove Wagons from Train',
        action: :remove_wagons_from_train
      },
      '4' => {
        name: 'Edit wagons',
        action: :edit_wagons,
      },
      '5' => {
          name: 'Move Train',
          action: :move_train
      },
      '0' => {
        name: 'Back to Main Menu',
        action: :display_main_menu
      }
    }
  }

  TRAINS_MENU = {
    title: 'Trains Menu',
    items: {
      '1' => {
        name: 'Add Train',
        action: [:display_menu, ADD_TRAIN_MENU]
      },
      '2' => {
        name: 'Edit Train',
        action: [:display_menu, EDIT_TRAIN_MENU]
      },
      '3' => {
        name: 'Train Info',
        action: :show_train_info
        # action: :
      },
      '0' => {
        name: 'Back to Main Menu',
        action: :display_main_menu
      }
    }
  }

  ROUTES_MENU = {
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

  MAIN_MENU = {
    title: 'Main Menu',
    items: {
      '1' => {
        name: 'Stations',
        action: [:display_menu, STATIONS_MENU]
      },
      '2' => {
        name: 'Trains',
        action: [:display_menu, TRAINS_MENU]
      },
      '3' => {
        name: 'Routes',
        action: [:display_menu, ROUTES_MENU]
      },
      '0' => {
        name: 'Exit',
        action: :exit
      }
    }
  }

  def initialize
    @routes = []
    @trains = []
    @wagons = []
  end
  
  def seed
    seed_stations
    seed_routes
    seed_trains
  end

  def seed_stations
    Station.new('Vnukovo')
    Station.new('Belorusskaya')
  end

  def seed_trains
    train1 = PassengerTrain.new('123-12')
    train2 = CargoTrain.new('154-53')
    wagon1 = PassengerWagon.new(24)
    wagon2 = CargoWagon.new(123.54)
    train1.add_wagon(wagon1)
    train2.add_wagon(wagon2)
    train1.set_route(@routes[0])
    train2.set_route(@routes[1])
    @trains.push(train1, train2)
  end

  def seed_routes
    stations = Station.all
    if stations.size >= 2
      @routes << Route.new(stations[0], stations[1])
      @routes << Route.new(stations[1], stations[0])
    end
  end

  def run
    display_main_menu
  end

  private

  def add_station
    puts 'Enter station name'
    station_name = gets.chomp
    Station.new(station_name)
    puts "Station '#{station_name}' was added"
    display_menu STATIONS_MENU
  rescue RuntimeError => e
    puts e.message
    puts 'Please, try again.'
    retry
  end

  def show_stations
    if Station.all.empty?
      puts 'There is no stations yet. Please, add one.'
    else
      puts 'Select station to view'
      selected_station = choose_item_from_array(Station.all)
      puts "#{selected_station.name} station."
      puts "Has no trains yet." if selected_station.trains.empty?
      selected_station.each_train { |train| puts train.description }
    end
    display_menu(STATIONS_MENU)
  end

  def handle_move_train(train)
    return puts "#{train.name} train has no assigned route" unless train.route
    select_train_destination(train)
    puts "#{train.name} train is now at #{train.current_station.name} station"
  end

  def move_train
    if @trains.empty?
      puts 'There are no trains to move. Please, create one.'
    else
      puts 'Select Train to move'
      selected_train = choose_item_from_array(@trains)
      handle_move_train(selected_train)
    end
    display_menu(TRAINS_MENU)
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
    puts 'Enter Train Number'
    train_number = gets.chomp
    new_train = type == 'cargo' ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
    @trains << new_train
    puts "#{type.capitalize} train ##{train_number} was added"
    display_menu(TRAINS_MENU)
  rescue RuntimeError => e
    puts e.message
    puts 'Please, try again.'
    retry
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
    display_menu(TRAINS_MENU)
  end

  def add_wagons_to_train
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      handle_add_wagon(selected_train)
    end
    display_menu(TRAINS_MENU)
  end

  def handle_add_wagon(train)
    wagon = nil
    if train.type == 'passenger'
      puts 'Enter number of seats'
      wagon = PassengerWagon.new(gets.chomp.to_i)
    else
      puts 'Enter wagon volume'
      wagon = CargoWagon.new(gets.chomp.to_f)
    end
    @wagons << wagon
    train.add_wagon(wagon)
    puts "#{wagon.name.capitalize} wagon was successfully added to #{train.name} train"
  end

  def remove_wagons_from_train
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      handle_remove_wagons(selected_train)
    end
    display_menu(TRAINS_MENU)
  end

  def handle_remove_wagons(train)
    return puts "#{train.name.capitalize} train has no wagons" if train.wagons.empty?
    puts 'Select wagon to remove'
    selected_wagon = choose_item_from_array(train.wagons)
    train.remove_wagon(selected_wagon)
    puts "#{selected_wagon.name.capitalize} wagon was successfully removed from #{train.name} train"
  end

  def edit_wagons
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      handle_edit_wagons(selected_train)
    end
    display_menu(TRAINS_MENU)
  end

  def handle_edit_wagons(train)
    return puts "#{train.name.capitalize} train has no wagons" if train.wagons.empty?
    puts 'Select wagon to edit'
    selected_wagon = choose_item_from_array(train.wagons)
    case selected_wagon.type
    when 'passenger' then edit_passenger_wagon(selected_wagon)
    when 'cargo' then edit_cargo_wagon(selected_wagon)
    else
      puts "Train type '#{train.type}' is not supported."
      display_menu(TRAINS_MENU)
    end
  end

  def edit_passenger_wagon(wagon)
    puts "Edit #{wagon.name} wagon"
    puts '1) Reserve Seat'
    puts '0) Back To Trains Menu'
    choice = gets.chomp.to_i
    case choice
    when 1
      wagon.reserve_seat
      puts 'Seat was successfully reserved.'
      puts wagon.description
    when 0 then display_menu(TRAINS_MENU)
    else
      puts 'There is no such option. Please, try again'
      edit_passenger_wagon(wagon)
    end
  end

  def edit_cargo_wagon(wagon)
    puts "Edit #{wagon.name} wagon"
    puts '1) Fill Wagon'
    puts '0) Back to Trains Menu'
    choice = gets.chomp.to_i
    case choice
    when 1
      puts 'Enter volume amount:'
      amount = gets.chomp.to_f
      wagon.fill_wagon(amount)
      puts "Wagon was successfully filled with #{amount} amount"
      puts wagon.description
    when 0 then display_menu(TRAINS_MENU)
    else
      puts 'There is no such option. Please, try again'
      edit_cargo_wagon(wagon)
    end
  end

  def add_route
    all_stations = Station.all
    if all_stations.size < 2
      puts 'There are not enough stations to create a route'
    else
      puts 'Select starting station:'
      starting_station = choose_item_from_array(all_stations)
      puts 'Select ending station:'
      rest_of_stations = all_stations.reject { |item| item == starting_station }
      ending_station = choose_item_from_array(rest_of_stations)
      @routes << Route.new(starting_station, ending_station)
      puts "Route '#{starting_station.name} - #{ending_station.name}' was created."
    end
    display_menu(ROUTES_MENU)
  end

  def show_train_info
    if @trains.empty?
      puts 'There are no trains yet. Please, add one.'
    else
      puts 'Select Train'
      selected_train = choose_item_from_array(@trains)
      handle_show_train_info(selected_train)
    end
    display_menu(TRAINS_MENU)
  end

  def handle_show_train_info(train)
    if train.wagons.empty?
      puts "#{train.name.capitalize} has no wagons yet"
    else
      puts "#{train.name.capitalize} wagons:"
      train.each_wagon { |wagon| puts wagon.description }
    end
  end

  def edit_route
    if @routes.empty?
      puts 'There are no routes to edit. Please, create one.'
      display_menu(ROUTES_MENU)
    else
      puts 'Select route to edit'
      selected_route = choose_item_from_array(@routes)
      display_edit_routes_menu(selected_route)
    end
  end

  def display_edit_routes_menu(route)
    puts 'Select option:'
    puts '1) Add Station'
    puts '2) Remove Station'
    puts '0) Back to Stations Menu'
    choice = gets.chomp.to_i
    case choice
    when 1 then add_stations_to_route(route)
    when 2 then remove_stations_from_route(route)
    when 0 then display_menu(STATIONS_MENU)
    else
      puts 'There is no such option. Please, try again'
      display_edit_routes_menu(route)
    end
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
    display_menu(ROUTES_MENU)
  end

  def choose_item_from_array(items)
    return unless items.is_a?(Array) && !items.empty?
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

  def add_stations_to_route(route)
    stations_to_add = Station.all - route.stations
    if stations_to_add.empty?
      puts 'There are no stations to add. Please, create more stations.'
    else
      selected_station = choose_item_from_array(stations_to_add)
      route.add_station(selected_station)
      puts "Station #{selected_station.name} was added to '#{route.name}' route"
    end
    display_menu(ROUTES_MENU)
  end

  def remove_stations_from_route(route)
    if route.way_stations.empty?
      puts "There are no stations to remove in '#{route.name}' route"
    else
      selected_station = choose_item_from_array(route.way_stations)
      route.remove_station(selected_station)
      puts "Station #{selected_station.name} was removed from '#{route.name}' route"
    end
    display_menu(ROUTES_MENU)
  end

  def display_menu(menu)
    puts menu[:title]
    menu[:items].each { |item| puts "#{item[0]}) #{item[1][:name]}" }
    menu_item = menu[:items][gets.chomp]
    if menu_item && menu_item[:action]
      send(*menu_item[:action])
    else
      puts 'There is no such option. Please, try again.'
      display_menu(menu)
    end
  end

  def display_main_menu
    display_menu(MAIN_MENU)
  end

  def exit
    puts 'See ya!!'
  end
end

my_app = App.new
my_app.seed
my_app.run
