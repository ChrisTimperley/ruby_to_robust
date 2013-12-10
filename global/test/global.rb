require_relative '../init.rb'

test_func = RubyToRobust::Global::RobustProc.new(['x', 'y'], 'x/0')

RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::DivideByZeroStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::NoMethodErrorStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new

r1 = RubyToRobust::Global.execute(test_func, [10, 44])
r2 = RubyToRobust::Global.execute(test_func, [89, 21])

puts "Result: #{r1}"
puts "Result: #{r2}"