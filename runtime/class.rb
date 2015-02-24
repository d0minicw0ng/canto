class CantoClass < CantoObject
  # Classes are objects in Canto so they inherit from CantoObject

  attr_reader :runtime_methods

  def initialize
    @runtime_methods = {}
    @runtime_class = Constants["Class"]
  end

  def lookup method_name
    method = @runtime_methods[method_name]
    raise "Method not found: #{method_name}" if method.nil?
    method
  end

  # Helper method to define a method on this class from Ruby
  def def name, &block
    @runtime_methods[name.to_s] = block
  end

  def new
    CantoObject.new self
  end

  def new_with_value value
    CantoObject.new self, value
  end
end
