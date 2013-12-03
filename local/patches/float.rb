# Ensures that any float divided by zero gives 0.0
RubyToRobust::Local.register_patch(Fixnum, :/, :__fdiv) do |other|
  other.zero? ? 0.0 : __fdiv(other)
end

# Ensures that the modulus operator returns zero if a divide
# by zero error would occur.
RubyToRobust::Local.register_patch(Float, :%, :__mod) do |other|
  other.zero? ? 0 : __mod(other)
end