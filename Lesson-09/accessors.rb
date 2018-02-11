module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        class_eval { attr_reader name }
        define_method("#{name}_history") { instance_variable_get("@#{name}_history") }
        define_method("#{name}=") do |value|
          instance_variable_set("@#{name}", value)
          history = instance_variable_get("@#{name}_history") || []
          instance_variable_set("@#{name}_history", history << value)
        end
      end
    end

    def strong_attr_accessor(name, type)
      class_eval { attr_reader name }
      define_method("#{name}=") do |value|
        raise "#{value.class} provided to #{name} (#{type} required)" unless value.is_a?(type)
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
