class Menu
  def initialize(storage)
    @storage = storage
  end

  def title
    'Menu'
  end

  def items
    {}
  end

  def display(context = {})
    puts title
    return if items.empty?
    items.each { |item| puts "#{item[0]}) #{item[1][:name]}" }
    menu_item = items.fetch(gets.chomp)
    @context = context
    send(*menu_item[:action])
  rescue KeyError
    puts 'There is no such option. Please, try again.'
    retry
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
