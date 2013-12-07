# Augments the ZeroDivisionError class to provide the line number that the ZeroDivisionError was encountered
# by some given method.
#
# WARNING: I'm not sure that this will work with the current form of RobustProc!
class ZeroDivisionError

  # Finds the line that the zero division error was thrown on (in
  # the monitored function). Without providing a method name, the
  # backtrace would determine which (unmonitored) method caused
  # the problem. We want to trap the problem inside the monitored
  # method instead!
  def line_no(method_name)
    backtrace.each do |b|
      return b[/:(\d+):/][1...-1].to_i - 1 if b.end_with? "#{method_name}'"
    end
    return nil
  end

end