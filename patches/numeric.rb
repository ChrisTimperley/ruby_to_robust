class Numeric

  # Ensures that integer division returns 0 if a division by zero
  # error occurs.
  alias_method :__div :div
  def div(numeric)
    begin
      return __div(numeric)
    rescue ZeroDivisionError
      return 0
    end
  end

  # Ensures that the modulus operator returns 0 if a division by zero
  # error occurs.
  alias_method :__divmod :divmod
  def divmod(numeric)
    begin
      return __divmod(numeric)
    rescue ZeroDivisionError
      return 0
    end
  end

end