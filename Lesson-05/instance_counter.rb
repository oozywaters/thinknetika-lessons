module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    private

    def register_instance
      self.class.send :add_instance, self
    end
  end

  module ClassMethods
    @@instances = []
    def instances
      @@instances.length
    end

    private

    def add_instance(instance)
      @@instances << instance
    end
  end
end
