# Validation methods module
module Validation
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Class methods for validation module
  module ClassMethods
    def validate(attr_name, validator, *params)
      include_validation unless validation_included?
      __validations[validator] ||= {}
      __validations[validator][attr_name] = params
    end

    def __validations
      class_variable_get(:@@__validations)
    end

    private

    def include_validation
      include(InstanceMethods)
      class_variable_set(:@@__validations, {})
    end

    def validation_included?
      ancestors.include?(InstanceMethods)
    end
  end

  # Instance methods for validation module
  module InstanceMethods
    def validate!
      self.class.__validations.each do |validator, attributes|
        attributes.each do |attr_name, params|
          var = instance_variable_get("@#{attr_name}")
          validator_method = "validate_#{validator}".to_sym
          send(validator_method, attr_name, var, *params)
        end
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    private

    def validate_presence(attr, value)
      raise "'#{attr}' attribute has no value" if value.nil? || value.empty?
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
end
