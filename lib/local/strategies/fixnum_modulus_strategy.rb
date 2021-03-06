# Ensures that the modulus operator returns zero if a divide
# by zero error would occur.
class ToRobust::Local::Strategies::FixnumModulusStrategy < ToRobust::Local::Strategies::SwapMethodStrategy

  # Constructs a new FixnumModulusStrategy.
  def initialize
    super(Fixnum, :%, :__mod) do |other|
      other.zero? ? 0 : __mod(other)
    end
  end

end