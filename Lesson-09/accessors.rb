module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        define_method(name) { instance_variable_get("@#{name}") }
        define_method("#{name}_history") { instance_variable_get("@#{name}_history") }
        define_method("#{name}=") do |value|
          history = instance_variable_get("@#{name}_history")
          current_value = instance_variable_get("@#{name}")
          history ? history << current_value : instance_variable_set("@#{name}_history", [])
          instance_variable_set("@#{name}", value)
        end
      end
    end

    def strong_attr_accessor(name, type)
      define_method(name) { instance_variable_get("@#{name}") }
      define_method("#{name}=") do |value|
        raise ArgumentError, "#{value.class} provided to #{name} (#{type} required)" unless value.is_a?(type)
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
