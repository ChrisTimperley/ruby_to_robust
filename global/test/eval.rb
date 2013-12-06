# This is AWESOME!
# Going to vastly improve performance!
# We can tell Ruby a file name and line number to report using.
class Klass
  class_eval <<-M, "I_AM_AN_EVAL", 0
    def div(x,y)
      z = "test!"
      return x/y
    end
  M
end

o = Klass.new
puts o.div(3,0)