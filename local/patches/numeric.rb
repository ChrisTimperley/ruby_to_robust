#  Ensures that integer division returns 0 if the denominator is zero.
RubyToRobust::Local.register_patch(Numeric, :div, :__div) do |other|
  other.zero? ? 0 : __div(other)
end

# Ensures that the modulus operator returns 0 if a division by zero
# error occurs.
RubyToRobust::Local.register_patch(Numeric, :divmod, :__divmod) do |other|
  other.zero? ? 0 : __divmod(other)
end