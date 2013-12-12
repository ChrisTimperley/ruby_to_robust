#  Ensures that integer division returns 0 if the denominator is zero.
class ToRobust::Local::Strategies::BignumModulusStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new BignumModulusStrategy.
  def initialize
    super(Bignum, :%, :__mod) do |other|
      other.zero? ? 0 : __mod(other)
    end
  end

end