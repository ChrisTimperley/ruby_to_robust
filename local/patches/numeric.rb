class Numeric

  # Ensures that integer division returns 0 if the denominator is zero.
  alias_method :__div :div
  def div(other)
    other.zero? ? 0 : __div(other)
  end

  # Ensures that the modulus operator returns 0 if a division by zero
  # error occurs.
  alias_method :__divmod :divmod
  def divmod(other)
    other.zero? 0 : __divmod(other)
  end

end