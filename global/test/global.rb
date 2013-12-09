require_relative '../init.rb'

test_func = RubyToRobust::Global::RobustProc.new(['x', 'y'], 'x/0')

RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::DivideByZeroStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::NoMethodErrorStrategy.new
RubyToRobust::Global.strategies << RubyToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new

puts "Result: #{RubyToRobust::Global.execute(test_func, [0, 1])}"