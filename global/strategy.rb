# Strategies are used by the global robustness layer to suggest candidate fixes to errors that occur
# within a given function.
class RubyToRobust::Global::Strategy

  # Generates a list of candidate fixes to a given problem.
  #
  # *Parameters:*
  # * method, the affected method.
  # * error, the error which occurred within the method.
  #
  # *Returns:*
  # An array of candidate solutions to fix the root of the error.
  def generate_candidates(method, error)
    raise NotImplementedError, 'No "generate_candidates" method was implemented by this Strategy.'
  end

end