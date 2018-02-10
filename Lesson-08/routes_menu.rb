require_relative 'menu'
require_relative 'route'

# Route editing menu
class RouteEditMenu < Menu
  def title
    "Edit Route '#{route.name}'"
  end

  def items
    {
      '1' => {
        name: 'Add Station',
        action: :add_station
      },
      '2' => {
        name: 'Remove Station',
        action: :remove_station
      },
      '0' => {
        name: 'Back to Routes Menu',
        action: :close!
      }
    }
  end

  def route
    @context[:route]
  end

  def display
    super if route
  end

  private

  def add_station
    stations_to_add = @storage.stations - route.stations
    return puts 'There are no stations to add. Please, create more stations.' if stations_to_add.empty?
    selected_station = choose_item_from_array(stations_to_add)
    route.add_station(selected_station)
    puts "Station #{selected_station.name} was added to '#{route.name}' route"
  end

  def remove_stations_from_route
    return puts "There are no stations to remove in '#{route.name}' route" if route.way_stations.empty?
    selected_station = choose_item_from_array(route.way_stations)
    route.remove_station(selected_station)
    puts "Station #{selected_station.name} was removed from '#{route.name}' route"
  end
end

# Main routes menu
class RoutesMenu < Menu
  def title
    'Routes Menu'
  end

  def items
    {
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
        action: :close!
      }
    }
  end

  private

  def add_route
    return puts 'There are not enough stations to create a route' if @storage.stations.size < 2
    puts 'Select Starting Station:'
    starting_station = choose_item_from_array(@storage.stations)
    puts 'Select Ending Station:'
    rest_of_stations = @storage.stations.reject { |item| item == starting_station }
    ending_station = choose_item_from_array(rest_of_stations)
    @storage.add_route(Route.new(starting_station, ending_station))
    puts "Route '#{starting_station.name} - #{ending_station.name}' was created."
  end

  def edit_route
    return puts 'There are no routes to edit. Please, create one.' unless @storage.routes?
    puts 'Select Route to Edit:'
    selected_route = choose_item_from_array(@storage.routes)
    RouteEditMenu.new(@storage, route: selected_route).display
  end

  def remove_route
    return puts 'There are no routes to delete.' unless @storage.routes?
    puts 'Select Route to Delete:'
    selected_route = choose_item_from_array(@storage.routes)
    @storage.delete_route(selected_route)
    puts "Route '#{selected_route.name}' was deleted"
  end
end
