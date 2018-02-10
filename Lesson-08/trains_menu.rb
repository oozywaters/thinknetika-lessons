require_relative 'menu'
require_relative 'cargo_train'
require_relative 'cargo_wagon'

# Wagon editing menu
class EditWagonMenu < Menu
  def title
    "Edit #{wagon.name} wagon"
  end

  def items
    if passenger?
      return {
        '1' => {
          name: 'Reserve Seat',
          action: :reserve_seat
        },
        '0' => {
          name: 'Cancel',
          action: :close!
        }
      }
    end
    {
      '1' => {
        name: 'Fill Wagon',
        action: :fill_wagon
      },
      '0' => {
        name: 'Cancel',
        action: :close!
      }
    }
  end

  def wagon
    @context[:wagon]
  end

  def passenger?
    wagon.type == 'passenger'
  end

  def cargo?
    wagon.type == 'cargo'
  end

  def display
    super if wagon
  end

  private

  def reserve_seat
    return unless passenger?
    wagon.reserve_seat
    puts 'Seat was successfully reserved.'
    puts wagon.description
  end

  def fill_wagon
    return unless cargo?
    puts "Enter volume amount(#{wagon.free_space} max):"
    amount = gets.chomp.to_f
    return unless wagon.fill_wagon(amount)
    puts "Wagon was successfully filled with #{amount} amount"
    puts wagon.description
  end
end

# Train destination menu
class MoveTrainMenu < Menu
  def title
    "Select #{train.name} destination"
  end

  def items
    {
      '1' => {
        name: "Next Station (#{train.next_station&.name})",
        action: :go_to_next_station
      },
      '2' => {
        name: "Previous Station (#{train.previous_station&.name})",
        action: :go_to_previous_station
      },
      '0' => {
        name: 'Cancel',
        action: :close!
      }
    }
  end

  def train
    @context[:train]
  end

  def display
    super if train
  end

  private

  def go_to_next_station
    train.go_to_next_station
    puts "Train #{train.name} is now at '#{train.current_station.name}' station"
  end

  def go_to_previous_station
    train.go_to_previous_station
    puts "Train #{train.name} is now at '#{train.current_station.name}' station"
  end
end

# Train creation menu
class AddTrainMenu < Menu
  def title
    'What Type of Train Do You Want to Add?'
  end

  def items
    {
      '1' => {
        name: 'Passenger',
        action: [:add_train, 'passenger']
      },
      '2' => {
        name: 'Cargo',
        action: [:add_train, 'cargo']
      },
      '0' => {
        name: 'Cancel',
        action: :close!
      }
    }
  end

  private

  def add_train(type)
    puts 'Enter Train Number'
    train_number = gets.chomp
    new_train = type == 'cargo' ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
    @storage.add_train(new_train)
    puts "#{type.capitalize} train ##{train_number} was added"
    close!
  rescue RuntimeError => e
    puts e.message
    puts 'Please, try again.'
    retry
  end
end

# Train Editing Menu
class EditTrainMenu < Menu
  def title
    "Edit Train #{train.name}"
  end

  # rubocop:disable Metrics/MethodLength
  def items
    {
      '1' => {
        name: 'Assign Route to Train',
        action: :assign_route
      },
      '2' => {
        name: 'Add Wagons to Train',
        action: :add_wagon
      },
      '3' => {
        name: 'Remove Wagons from Train',
        action: :remove_wagon
      },
      '4' => {
        name: 'Edit wagons',
        action: :edit_wagon
      },
      '5' => {
        name: 'Move Train',
        action: :move_train
      },
      '0' => {
        name: 'Back to Main Menu',
        action: :close!
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  def train
    @context[:train]
  end

  def display
    super if train
  end

  def passenger?
    train.type == 'passenger'
  end

  def cargo?
    train.type == 'cargo'
  end

  private

  def assign_route
    return puts 'There are no routes to assign yet. Please, add one.' unless @storage.routes?
    puts "Selecte Route to Assign #{train.name} Train"
    train.route = choose_item_from_array(@storage.routes)
    puts "#{train.route.name} Route was successfully Assigned to #{train.name} Train"
  end

  def create_wagon
    if passenger?
      puts 'Enter Number of Seats:'
      PassengerWagon.new(gets.chomp.to_i)
    elsif cargo?
      puts 'Enter Wagon Volume:'
      CargoWagon.new(gets.chomp.to_f)
    end
  end

  def add_wagon
    wagon = create_wagon
    @storage.add_wagon(wagon)
    train.add_wagon(wagon)
    puts "#{wagon.name.capitalize} wagon was successfully added to #{train.name} train"
  end

  def select_wagon
    return puts "#{train.name.capitalize} train has no wagons" if train.wagons.empty?
    puts 'Select Wagon:'
    wagon = choose_item_from_array(train.wagons)
    yield(wagon) if block_given?
  end

  def remove_wagon
    select_wagon { |wagon| handle_remove_wagon(wagon) }
  end

  def edit_wagon
    select_wagon { |wagon| handle_edit_wagon(wagon) }
  end

  def handle_remove_wagon(wagon)
    train.remove_wagon(wagon)
    puts "#{wagon.name.capitalize} wagon was successfully removed from #{train.name} train"
  end

  def handle_edit_wagon(wagon)
    EditWagonMenu.new(@storage, wagon: wagon).display
  end

  def move_train
    return puts "#{train.name} train has no assigned route" unless train.route
    MoveTrainMenu.new(@storage, train: train).display
  end
end

# Main Trains Menu
class TrainsMenu < Menu
  def title
    'Trains Menu'
  end

  def items
    {
      '1' => {
        name: 'Add Train',
        action: :add_train
      },
      '2' => {
        name: 'Edit Train',
        action: :edit_train
      },
      '3' => {
        name: 'Train Info',
        action: :show_train_info
      },
      '0' => {
        name: 'Back to Main Menu',
        action: :close!
      }
    }
  end

  def add_train
    AddTrainMenu.new(@storage).display
  end

  def edit_train
    select_train { |train| EditTrainMenu.new(@storage, train: train).display }
  end

  def show_train_info
    select_train do |train|
      return puts "#{train.name.capitalize} has no wagons yet" if train.wagons.empty?
      puts "#{train.name.capitalize} wagons:"
      train.each_wagon { |wagon| puts wagon.description }
    end
  end

  def select_train
    return puts 'There are no trains yet. Please, add one.' unless @storage.trains?
    puts 'Select Train:'
    train = choose_item_from_array(@storage.trains)
    yield(train) if block_given?
  end

  def handle_show_train_info(train)
    return puts "#{train.name.capitalize} has no wagons yet" if train.wagons.empty?
    puts "#{train.name.capitalize} wagons:"
    train.each_wagon { |wagon| puts wagon.description }
  end
end
