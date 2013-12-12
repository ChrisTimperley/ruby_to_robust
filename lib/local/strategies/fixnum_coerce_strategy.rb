# Coerce nil to 0.
class ToRobust::Local::Strategies::FixnumCoerceStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new FixnumCoerceStrategy.
  def initialize
    super(Fixnum, :coerce, :__coerce) do |other|
      other.nil? ? 0 : __coerce(other)
    end
  end

end