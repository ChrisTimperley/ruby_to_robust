# Augments the ZeroDivisionError class to provide the line number that the ZeroDivisionError was encountered
# by some given method.
#
# WARNING: I'm not sure that this will work with the current form of RobustProc!
class ZeroDivisionError

  # Finds the line that the zero division error was first thrown on by
  # a given method (not the first line that it occurs at, since this may
  # be within a non-robust method).
  #
  # *Parameters:*
  # * method, the method to extract the line number for.
  #
  # *Returns:*
  # The line that the error occurred on within the provided method.
  def line_no(method)
    backtrace.each do |b|
      return b[/:(\d+):/][1...-1].to_i if b.start_with?(method.code)
    end
    return nil
  end

end