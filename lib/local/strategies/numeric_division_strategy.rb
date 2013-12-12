#  Ensures that integer division returns 0 if the denominator is zero.
class RubyToRobust::Local::Strategies::NumericDivisionStrategy < RubyToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new NumericDivisionStrategy.
  def initialize
    super(Numeric, :div, :__div) do |other|
      other.zero? ? 0 : __div(other)
    end
  end

end