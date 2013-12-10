# Ensures that the modulus operator returns zero if a divide
# by zero error would occur.
class RubyToRobust::Local::Strategies::FloatModulusStrategy < RubyToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new FloatModulusStrategy.
  def initialize
    super(Float, :%, :__mod) do |other|
      other.zero? ? 0.0 : __mod(other)
    end
  end

end