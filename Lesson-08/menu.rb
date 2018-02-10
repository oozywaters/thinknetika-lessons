# Core menu functionality
class Menu
  def initialize(storage, context = {})
    @storage = storage
    @context = context
    @close = false
  end

  def title
    'Menu'
  end

  def items
    {}
  end

  def display
    return if items.empty?
    render until @close
  end

  protected

  def close!
    @close = true
  end

  def render
    puts title
    items.each { |key, value| puts "#{key}) #{value[:name]}" }
    handle_user_input
  rescue KeyError
    puts 'There is no such option. Please, try again.'
    retry
  end

  def handle_user_input
    menu_item = items.fetch(gets.chomp)
    send(*menu_item[:action])
  end

  def choose_item_from_array(items)
    return unless items.is_a?(Array) && !items.empty?
    display_array_items(items)
    items.fetch(gets.chomp.to_i - 1)
  rescue IndexError
    puts 'There is no such option. Please, try again.'
    retry
  end

  def display_array_items(items)
    return puts 'There is no items to display.' if items.empty?
    items.each_with_index do |item, index|
      puts "#{index + 1}) #{item.name}" if item.class.method_defined? :name
    end
  end
end
