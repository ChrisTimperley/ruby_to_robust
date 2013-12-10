def Class

  # Marks this class an abstract class.
  def abstract_class
    @abstract_class = true
  end

  # Checks to see if this class is abstract.
  def abstract_class?
    @abstract_class || false
  end

end