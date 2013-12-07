# Augments the functionality of ArgumentError instances so that the affected method and expected number
# of arguments can be quickly inspected. Also adjusts the line number calculation so that the correct
# line number is returned for the error.
class ArgumentError

  # Returns the name of the method which was provided with poorly formed arguments.
  def affected_method
    backtrace[0].match(/`(([a-zA-Z]|_)+)'/)[0][1...-1]
  end

  # Returns the number of arguments that were expected by this method.
  def args_expected
    message.match(/\s(\d+)\)/)[0][1...-1].to_i
  end

  # Returns the line number that the method call was made from.
  # The line that the method call was made is given by the second line of the backtrace.
  def line_no
    backtrace[1][/:(\d+):/][1...-1].to_i - 1
  end

end