require_relative 'menu'
require_relative 'cargo_train'
require_relative 'cargo_wagon'

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

class EditTrainMenu < Menu
  def title
    'Edit Train'
  end

  def items
    {
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
        action: :close!
      }
    }
  end
end

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
    EditTrainMenu.new(@storage).display
  end

  def show_train_info
    return puts 'There are no trains yet. Please, add one.' unless @storage.trains?
    puts 'Select Train'
    selected_train = choose_item_from_array(@storage.trains)
    handle_show_train_info(selected_train)
  end

  def handle_show_train_info(train)
    return puts "#{train.name.capitalize} has no wagons yet" if train.wagons.empty?
    puts "#{train.name.capitalize} wagons:"
    train.each_wagon { |wagon| puts wagon.description }
  end
end
