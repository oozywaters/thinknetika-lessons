require_relative 'vendor'

class Wagon
  include Vendor

  attr_reader :type, :number, :space, :free_space

  def initialize(type = 'passenger', space)
    @type = type
    @number = Array.new(5) { rand(36).to_s(36) }.join
    @space = space
    @free_space = space
  end

  def name
    "#{@type} ##{@number}"
  end

  def take_space(amount)
    return if @free_space.zero?
    @free_space -= amount if @free_space >= amount
  end

  def occupied_space
    @space - @free_space
  end

  def description
    "Wagon ##{number}, type: #{type}"
  end
end
