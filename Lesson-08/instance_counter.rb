# Counts instances :)
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # Instance methods and variables
  module InstanceMethods
    private

    def register_instance
      self.class.send :add_instance
    end
  end

  # Class methods
  module ClassMethods
    attr_reader :instances

    private

    def add_instance
      @instances ||= 0
      @instances += 1
    end
  end
end
