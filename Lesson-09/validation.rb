# Validation methods module
module Validation
  def self.included(base)
    base.class_variable_set(:@@validations, {})
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  # Class methods for validation module
  module ClassMethods
    def validate(attr_name, validator, *params)
      validations = class_variable_get(:@@validations)
      validations[validator] ||= {}
      validations[validator][attr_name] = params
    end

    private

    def validate_presence(attr, value)
      raise "#{attr} attribute has no value" if value.nil? || value.empty?
    end

    def validate_format(attr, value, format)
      raise "'#{attr}' attribute has wrong format" if value !~ format
    end

    def validate_type(attr, value, type)
      mismatch =
        if value.is_a?(Array) && type.is_a?(Array)
          value.any? { |item| !item.is_a?(type[0]) }
        else
          !value.is_a?(type)
        end
      raise "'#{attr}' has wrong type (#{type} expected)" if mismatch
    end
  end

  # Instance methods for validation module
  module InstanceMethods
    def validate!
      validations = self.class.class_variable_get(:@@validations)
      validations.each do |validator, attributes|
        attributes.each do |attr_name, params|
          var = instance_variable_get("@#{attr_name}")
          validator_method = "validate_#{validator}".to_sym
          self.class.send(validator_method, attr_name, var, *params)
        end
      end
    end

    def valid?
      validate!
    rescue RuntimeError
      false
    end
  end
end
