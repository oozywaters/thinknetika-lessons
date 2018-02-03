module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.instance_variable_set(:@instances, [])
  end

  module InstanceMethods
    private

    def register_instance
      self.class.send :add_instance, self
    end
  end

  module ClassMethods
    def instances
      @instances.length
    end

    private

    def add_instance(instance)
      @instances << instance
    end
  end
end
