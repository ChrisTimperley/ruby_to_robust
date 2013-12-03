class Object

  # Returns the meta-class of this object.
  def metaclass
    class << self; self; end
  end

  # Removes all the (non-inherited/instance) methods from this context/object and
  # stores them inside a private method look-up table, indexed by the string form
  # of their name. 
  def collapse_methods!
    @__methods = Hash[instance_methods.map{ |name|
      m = method(name)
      metaclass.send(:remove_method, name)
      [name.to_s, m]
    }]
  end

  # Restores each method in the private method look-up table as an instance method
  # before clearing the contents of the look-up table.
  def restore_methods!
    @__methods.each_pair do |name, m|
      metaclass.send(:define_method, name, m)
    end
    @__methods.clear
  end

end