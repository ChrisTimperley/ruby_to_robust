# Ensures that any float divided by zero gives 0.0
class ToRobust::Local::Strategies::FloatDivisionStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new FloatDivisionStrategy.
  def initialize
    super(Float, :/, :__fdiv) do |other|
      other.zero? ? 0.0 : __fdiv(other)
    end
  end

end