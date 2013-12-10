require_relative '../init.rb'

module TestFunctions

  def self.add(x, y)
    x+y
  end

  def self.div(x, y)
    x/y
  end

  def self.mul(x, y)
    x*y
  end

end

test_func = "TestFunctions.ad(x, y)"
test_func = RubyToRobust::Global::RobustProc.new(['x', 'y'], test_func)

RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::DivideByZeroStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::NoMethodErrorStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new

r1 = RubyToRobust::Global.execute(test_func, [10, 44])
r2 = RubyToRobust::Global.execute(test_func, [89, 21])

puts "Result: #{r1}"
puts "Result: #{r2}"