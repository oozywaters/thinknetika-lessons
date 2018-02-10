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
    until @close
      puts title
      items.each { |item| puts "#{item[0]}) #{item[1][:name]}" }
      menu_item = items.fetch(gets.chomp)
      send(*menu_item[:action])
    end
  rescue KeyError
    puts 'There is no such option. Please, try again.'
    retry
  end

  def close!
    @close = true
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
end
