# Robustness strategy for dealing with ArgumentError's thrown due to incorrect numbers of
# arguments being supplied to a method. Trims or pads the list of arguments so that the number
# of arguments is equal to the arity of the method (i.e. the number of provided arguments
# matches the expected number of arguments).
class RubyToRobust::Global::Strategies::WrongArgumentsErrorStrategy < RubyToRobust::Global::Strategy

  # Fixes all calls to a given method on a provided line such that they all use
  # an expected number of arguments. Method calls with too few parameters are padded with zeroes,
  # whilst method calls with too many parameters are trimmed to the correct size.
  #
  # *Parameters:*
  # * method, the method to fix calls to.
  # * arity, the arity (expected number of parameters) of the method.
  # * line, the line to fix method calls on.
  #
  # *Returns:*
  # The fixed form of the line, with all calls to the given method meeting the argument length requirements.
  def self.fix_calls(method, arity, line)

    # Extract all calls to the affected method on the given line.
    calls = extract_calls(line)
    calls.reject! do |c|
      method_full_name = line[c[0]...line.index('(', c[0])].split(/\.|::/)
      method_full_name.last != method
    end
    
    # Re-order calls so that nested calls are processed first.
    # First, order the calls by their starting position.
    # Secondly, create a new list and insert each call at an smaller
    # index to any calls that enclose it.
    calls.sort!{|a,b| a[0] <=> b[0]}
    temp = []
    calls.each do |x|
      index = insert_at = temp.length
      if insert_at > 0
        temp.reverse_each do |y|
          index -= 1
          insert_at = index if y[0] < x[0] and y[1] > x[1]
        end
      end
      temp.insert(insert_at, x)
    end
    calls = temp
    
    # Process each of the calls (in the safe order that has 
    # been established). Begin by extracting the current arguments
    # for the method call, then either padding or shrinking those
    # arguments to meet the required length.
    calls.each_index do |call_index|
    
      meth_start, meth_end = calls[call_index]
      params_start = line.index('(', meth_start)+1
      arg_start = params_start
      
      # Process each character in the body of parameters.
      open_brackets = 0
      arguments = []
      for char_index in params_start...meth_end
        
        # Extract the character at the given point in the call.
        char = line[char_index]
      
        # Listen for bracket closings.
        if char == '('
          open_brackets += 1
          
        # Listen for any bracket openings.
        elsif char == ')'
          open_brackets -= 1
          
        # Check if this character marks the end of the argument.
        # Only interpret it as the end of the argument if there are
        # no open brackets.
        elsif char == ',' and open_brackets == 0
          arguments << [arg_start, char_index-1]
          arg_start = char_index + 1
        end
        
      end
      
      # Add the last argument.
      arguments << [arg_start, meth_end-1]
      
      # Shrink the arguments to the limit (better to do this before
      # extracting their text contents, small optimisation), then
      # retrieve their context contents (stripping any leading and
      # trailing whitespace) and pad the arguments with zeroes
      # where necessary.
      arguments = arguments.first(arity)
      arguments.map!{|a_start, a_end| line[a_start..a_end].strip}
      arguments.fill('0', arguments.length...arity)
      
      # Apply the transformation, calculate the length difference (delta)
      # and re-adjust the boundaries of the remaining method calls.
      transformed = "#{line[meth_start...line.index('(', meth_start)]}(#{arguments.join(',')})"
      delta = transformed.length - (meth_end - meth_start + 1)
      line[meth_start..meth_end] = transformed
      (call_index+1...calls.length).each do |succ_call_index|
      
        # Find the start and end points of the call.
        succ_call_start, succ_call_end = calls[succ_call_index]
        
        # Move the end point of any call containing the call that
        # has been transformed.
        if succ_call_start < meth_start and succ_call_end > meth_end
          calls[succ_call_index][1] += delta
      
        # Move the start and end points of each call that
        # starts after the end of this call. (You could embed this
        # within the if statement above, but this is nicer to read).
        elsif succ_call_start > meth_end
          calls[succ_call_index][0] += delta
          calls[succ_call_index][1] += delta
        end
        
      end
      
    end
    
    # Return the transformed line.
    return line

  end

  # Used to fix ArgumentError exceptions by ensuring that all calls to a given method
  # on the line that the error occurred on use the expected number of arguments.
  #
  # When too few arguments are used during a method call, those arguments are padded
  # with zeroes to reach the correct number of parameters.
  #
  # When too many arguments are supplied to a method, those arguments are trimmed to
  # the number of arguments expected by the method.
  #
  # *Parameters:*
  # * method, the affected method.
  # * error, the error whose root cause should be fixed.
  #
  # *Returns:*
  # A (possibly empty) array of candidate fixes to the root cause of the error.
  def generate_candidates(method, error)

    # Ensure that the error is a ArgumentError caused by an incorrect number
    # of arguments being supplied to a method.
    return [] unless error.is_a? ArgumentError and error.message.include? 'wrong number of arguments'

    # Extract details of the error.
    affected_method = error.affected_method
    args_expected = error.args_expected
    line_no = error.line_no
    line_contents = method.source[line_no]
    
    # We validate the fix by ensuring that any further errors are not
    # ArgumentErrors for the incorrect number of arguments on the same
    # method and on the same line.
    validator = lambda do |method, old_error, new_error|
      return true unless new_error.is_a? ArgumentError
      return true unless new_error.message.include? 'wrong number of arguments'
      return true unless new_error.line_no == old_error.line_no
      return true unless new_error.affected_method == old_error.affected_method
      return false
    end
    
    # Compose the sole candidate fix for this error.
    line_contents = self.class.fix_calls(affected_method, args_expected, line_contents)
    return [
      RubyToRobust::Global::Fix.new(
        [RubyToRobust::Global::Fix::SwapAtom.new(line_no, line_contents)],
        validator
      )
    ]

  end

end