require_relative 'menu'
require_relative 'storage'
require_relative 'stations_menu'
require_relative 'trains_menu'

class App < Menu
  EDIT_ROUTE_MENU = {
    title: 'Edit Route Menu',
    items: {
      '1' => {
        name: 'Add Station',
        action: :add_stations_to_route
      },
      '2' => {
        name: 'Remove Station',
        action: :remove_stations_from_route
      },
      '0' => {
        name: 'Back to Routes Menu',
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

  def title
    'Main Menu'
  end

  def items
    {
      '1' => {
        name: 'Stations',
        action: :show_stations_menu
      },
      '2' => {
        name: 'Trains',
        action: :show_trains_menu
      },
      '3' => {
        name: 'Routes',
        action: [:display_menu, ROUTES_MENU]
      },
      '0' => {
        name: 'Exit',
        action: :close!
      }
    }
  end

  def run
    display
  end

  private

  def show_stations_menu
    StationsMenu.new(@storage).display
  end

  def show_trains_menu
    TrainsMenu.new(@storage).display
  end

  def add_route
    all_stations = @storage.stations
    if all_stations.size < 2
      puts 'There are not enough stations to create a route'
    else
      puts 'Select starting station:'
      starting_station = choose_item_from_array(all_stations)
      puts 'Select ending station:'
      rest_of_stations = all_stations.reject { |item| item == starting_station }
      ending_station = choose_item_from_array(rest_of_stations)
      @storage.add_route(Route.new(starting_station, ending_station))
      puts "Route '#{starting_station.name} - #{ending_station.name}' was created."
    end
    display_menu(ROUTES_MENU)
  end

  def edit_route
    if !@storage.routes?
      puts 'There are no routes to edit. Please, create one.'
      display_menu(ROUTES_MENU)
    else
      puts 'Select route to edit'
      selected_route = choose_item_from_array(@storage.routes)
      display_menu(EDIT_ROUTE_MENU, route: selected_route)
    end
  end

  def remove_route
    if !@storage.routes?
      puts 'There are no routes to delete.'
    else
      puts 'Select route to delete:'
      selected_route = choose_item_from_array(@storage.routes)
      @storage.delete_route(selected_route)
      puts "Route '#{selected_route.name}' was deleted"
    end
    display_menu(ROUTES_MENU)
  end

  def add_stations_to_route(route:)
    stations_to_add = @storage.stations - route.stations
    if stations_to_add.empty?
      puts 'There are no stations to add. Please, create more stations.'
    else
      selected_station = choose_item_from_array(stations_to_add)
      route.add_station(selected_station)
      puts "Station #{selected_station.name} was added to '#{route.name}' route"
    end
    display_menu(EDIT_ROUTE_MENU, route: route)
  end

  def remove_stations_from_route(route:)
    if route.way_stations.empty?
      puts "There are no stations to remove in '#{route.name}' route"
    else
      selected_station = choose_item_from_array(route.way_stations)
      route.remove_station(selected_station)
      puts "Station #{selected_station.name} was removed from '#{route.name}' route"
    end
    display_menu(EDIT_ROUTE_MENU, route: route)
  end

  def close!
    super
    puts 'See ya!!'
  end
end

storage = Storage.new
storage.seed
my_app = App.new(storage)
my_app.run
