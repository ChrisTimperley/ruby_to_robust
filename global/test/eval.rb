# This is AWESOME!
# Going to vastly improve performance!
# We can tell Ruby a file name and line number to report using.
class CleverLambda
end

o = CleverLambda.new
code = "def call(x,y)
  z = 'test!'
  return x/y
end"
o.instance_eval(code, "I_AM_A_CLEVER_LAMBDA", 0)

puts o.call(3,0)