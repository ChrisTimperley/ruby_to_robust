# Implements a local robustness strategy.
#
# These strategies are used to implement "softer" semantics in the program.
class RubyToRobust::Local::Strategy

  # Prepares this strategy.
  #
  # *Parameters:*
  # * contexts, a list of contexts that Local robustness is operating under.
  def prepare!(contexts); end

  # Enables this patch.
  def enable!; end

  # Disables this patch.
  def disable!; end

end