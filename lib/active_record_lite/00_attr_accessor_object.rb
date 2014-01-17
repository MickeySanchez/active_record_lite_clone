class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}") do
        self.instance_variable_get("@#{name}".to_sym)
      end

      define_method("#{name}=") do |value|
        self.instance_variable_set("@#{name.to_s}".to_sym, value)
      end
    end
  end
end
