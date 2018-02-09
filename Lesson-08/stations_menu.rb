require_relative 'menu'

class StationsMenu < Menu
  def title
    'Stations Menu'
  end

  def items
    {
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
  end

  def add_station
    puts 'Enter station name'
    station_name = gets.chomp
    @storage.add_station(Station.new(station_name))
    puts "Station '#{station_name}' was added"
    display
  rescue RuntimeError => e
    puts e.message
    puts 'Please, try again.'
    retry
  end

  def show_stations
    if @storage.stations?
      puts 'Select station to view'
      selected_station = choose_item_from_array(@storage.stations)
      puts "#{selected_station.name} station."
      puts "Has no trains yet." if selected_station.trains.empty?
      selected_station.each_train { |train| puts train.description }
    else
      puts 'There is no stations yet. Please, add one.'
    end
    display
  end
end
