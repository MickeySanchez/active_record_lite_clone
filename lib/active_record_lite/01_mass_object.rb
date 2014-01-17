require_relative '00_attr_accessor_object.rb'

class MassObject < AttrAccessorObject
  def self.my_attr_accessible(*new_attributes)
    new_attributes.each do |attribute|
      self.attributes << attribute
    end
  end

  def self.attributes
    if self == MassObject
      raise "must not call #attributes on MassObject directly"
    end
    @attributes ||= []
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

      unless self.class.attributes.include?(attr_name)
        raise "mass assignment to unregistered attribute '#{attr_name}'"
      end

      self.send("#{attr_name}=", value)
    end
  end
end
