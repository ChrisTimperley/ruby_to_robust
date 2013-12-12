# Ensures that the modulus operator returns 0 if a division by zero
# error occurs.
class ToRobust::Local::Strategies::NumericModulusStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new NumericModulusStrategy.
  def initialize
    super(Numeric, :divmod, :__divmod) do |other|
      other.zero? ? 0 : __divmod(other)
    end
  end

end