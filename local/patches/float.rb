class Float

  # Ensures that any float divided by zero gives 0.0
  alias_method :__fdiv, :/
  def /(other)
    other.zero? ? 0.0 : __fdiv(other)
  end
  
  # Ensures that the modulus operator returns zero if a divide
  # by zero error would occur.
  alias_method :__modulo, :modulo
  def %(other)
    other.zero? ? 0 : __modulo(other)
  end
  alias_method :modulo, :%

end