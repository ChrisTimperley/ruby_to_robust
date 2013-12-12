# Strategies are used by the global robustness layer to suggest candidate fixes to errors that occur
# within a given function.
class RubyToRobust::Global::Strategy

  # Extracts the co-ordinates of all method calls on a given line.
  #
  # *Parameters:*
  # * line, the line to extract method calls from.
  #
  # *Returns:*
  # An array of co-ordinate pairs (each an array - could use a range?).
  def self.extract_calls(line)

    # Find the co-ordinates of every method call in the string.
    stack = []
    calls = []
    (0..line.length).each do |index|

      # Get the character at this index.
      char = line[index]

      # If this is the start of a method call,
      # add the starting index to the stack.
      if char == '('
        stack << index

      # If this is the end of a method call,
      # pop the last index off the stack and combine
      # it with the current index to give the co-ordinates
      # of the call.
      elsif char == ')'
        calls << [stack.pop, index]
      end

    end

    # Post-process the co-ordinates so that they start from the label
    # of the method call rather than the bracket opening. Do this by
    # moving towards the start of the original string until the method
    # definition has finished (checked by looking at the character).
    calls.each_index do |i|
      start_at = calls[i][0]
      until start_at == 0 do
        char = line[start_at-1]
        break if not (char.match(/^[[:alpha:]]$/) or ['_',':','.'].include? char)
        start_at -= 1
      end
      calls[i][0] = start_at
    end

    return calls
    
  end

  # Generates a list of candidate fixes to a given problem.
  #
  # *Parameters:*
  # * method, the affected method.
  # * error, the error which occurred within the method.
  #
  # *Returns:*
  # A (possibly empty) array of candidate solutions to fix the root of the error.
  def generate_candidates(method, error)
    raise NotImplementedError, 'No "generate_candidates" method was implemented by this Strategy.'
  end

end