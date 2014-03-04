# encoding: utf-8

require 'test/unit'

class GlobalTestCase < Test::Unit::TestCase

  def setup
    ToRobust::Global.strategies << ToRobust::Global::Strategies::DivideByZeroStrategy.new
    ToRobust::Global.strategies << ToRobust::Global::Strategies::NoMethodErrorStrategy.new(5)
    ToRobust::Global.strategies << ToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new
  end

  def teardown
    ToRobust::Global.strategies.clear
  end

end
