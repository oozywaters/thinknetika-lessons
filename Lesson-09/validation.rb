# Validation methods module
module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def validate(attr_name, *params)
      'validate!'
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue RuntimeError
      false
    end
  end
end
