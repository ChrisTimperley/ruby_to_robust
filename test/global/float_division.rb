# encoding: utf-8

require_relative 'base'
require_relative '../../lib/to_robust'
 
class TestFloatDivision < GlobalTestCase

  def setup
    ToRobust::Global.strategies << ToRobust::Global::Strategies::DivideByZeroStrategy.new
    ToRobust::Global.strategies << ToRobust::Global::Strategies::NoMethodErrorStrategy.new(
      max_distance: 5
    )
    ToRobust::Global.strategies << ToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new
  end

  def teardown
    ToRobust::Global.strategies.clear
  end

  def test_standard_behaviour
    program = lambda { |x, y| x / y }
    assert_equal(5.0, ToRobust::Global.execute(program, [50.0, 10.0]))
    assert_equal(5.0, program[50.0, 10.0])
  end
 
  def test_hard_dbz
    program = lambda { |x, y| x / y }
    assert_equal(Float::INFINITY, program[1.0, 0.0])
    assert_equal(Float::INFINITY, program[2.0, 0.0])
    assert_equal(Float::INFINITY, program[10.0, 0.0])
    assert_equal(Float::INFINITY, program[255.0, 0.0])
  end

  def test_soft_dbz
    program = lambda { |x, y| x / y }
    assert_equal(0.0, ToRobust::Global.execute(program, [1.0, 0.0]))
    assert_equal(0.0, ToRobust::Global.execute(program, [2.0, 0.0]))
    assert_equal(0.0, ToRobust::Global.execute(program, [10.0, 0.0]))
    assert_equal(0.0, ToRobust::Global.execute(program, [255.0, 0.0]))
  end
 
end
