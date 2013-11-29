class Bignum

	# Ensures that Bignum division never encounters zero division errors
  # by returning zero when the denominator is zero. 
  alias_method :__div :/
  def /(other)
    return __div(other) unless other.zero?
    return other.kind_of? Float ? 0.0 : 0
  end
	
	# Ensures that the modulus operator returns zero if a divide
  # by zero error would occur.
  alias_method :__modulo :modulo
  def %(other)
    other.zero? 0 : __modulo(other)
  end
  alias_method :modulo :%

end