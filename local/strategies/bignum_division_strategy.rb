#  Ensures that integer division returns 0 if the denominator is zero.
class RubyToRobust::Local::Strategies::BignumDivisionStrategy < RubyToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new BignumDivisionStrategy.
  def initialize
    super(Bignum, :div, :__div) do |other|
      other.zero? ? 0 : __div(other)
    end
  end

end