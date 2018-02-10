require_relative 'menu'
require_relative 'storage'
require_relative 'stations_menu'
require_relative 'trains_menu'
require_relative 'routes_menu'

# Main App class
class App < Menu
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
        action: :show_routes_menu
      },
      '0' => {
        name: 'Exit',
        action: :close!
      }
    }
  end

  private

  def show_stations_menu
    StationsMenu.new(@storage).display
  end

  def show_trains_menu
    TrainsMenu.new(@storage).display
  end

  def show_routes_menu
    RoutesMenu.new(@storage).display
  end

  def close!
    super
    puts 'See ya!!'
  end

  alias_method :run, :display
end

storage = Storage.new
storage.seed
App.new(storage).run
