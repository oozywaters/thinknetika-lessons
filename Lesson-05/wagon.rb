require_relative 'vendor'

class Wagon
  include Vendor

  attr_reader :type, :number

  def initialize(type = 'passenger')
    @type = type
    @number = Array.new(5) { rand(36).to_s(36) }.join
  end

  def name
    "#{@type} ##{@number}"
  end
end
