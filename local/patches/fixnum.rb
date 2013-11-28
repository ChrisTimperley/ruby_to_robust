class Fixnum

  # Coerce nil to 0.
  alias_method :__coerce :coerce
  def coerce(other)
    other.nil? 0 : __coerce(other)
  end

  # Ensures that Fixnum division never encounters zero division errors
  # by returning zero when the denominator is zero. 
  alias_method :__div :/
  def /(other)
    return __div(other) unless other.zero?
    return other.kind_of? Float ? 0.0 : 0
  end
  
  # Ensures that the modulus operator returns zero if a divide
  # by zero error would occur.
  alias :__modulo :modulo
  def %(other)
    other.zero? 0 : __modulo(other)
  end
  alias :modulo :%
  
end