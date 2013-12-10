# Coerce nil to 0.
RubyToRobust::Local.register_patch(Fixnum, :coerce, :__coerce) do |other|
  other.nil? ? 0 : __coerce(other)
end

# Ensures that Fixnum division never encounters zero division errors
# by returning zero when the denominator is zero.
RubyToRobust::Local.register_patch(Fixnum, :/, :__div) do |other|
  return __div(other) unless other.zero?
  return other.kind_of?(Float) ? 0.0 : 0
end

# Ensures that the modulus operator returns zero if a divide
# by zero error would occur.
RubyToRobust::Local.register_patch(Fixnum, :%, :__mod) do |other|
  other.zero? ? 0 : __mod(other)
end