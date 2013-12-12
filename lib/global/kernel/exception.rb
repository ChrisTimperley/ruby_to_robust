# Augments the functionality of the Exception class to make error debugging simpler.
class Exception

  # Returns the line number that this exception was thrown on.
  def line_no
    backtrace[0][/:(\d+):/][1...-1].to_i
  end

end