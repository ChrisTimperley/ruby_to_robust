#  Ensures that integer division returns 0 if the denominator is zero.
class RubyToRobust::Local::Strategies::BignumModulusStrategy < RubyToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new BignumModulusStrategy.
  def initialize
    super(Bignum, :%, :__mod) do |other|
      other.zero? ? 0 : __mod(other)
    end
  end

end