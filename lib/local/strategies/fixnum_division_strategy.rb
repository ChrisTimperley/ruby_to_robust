# Ensures that Fixnum division never encounters zero division errors
# by returning zero when the denominator is zero.
class ToRobust::Local::Strategies::FixnumDivisionStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new FixnumDivisionStrategy.
  def initialize
    super(Fixnum, :/, :__div) do |other|
      other.zero? ? 0 : __div(other)
    end
  end

end