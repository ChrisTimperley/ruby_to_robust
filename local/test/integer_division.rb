require_relative '../../init.rb'
require 'test/unit'
 
class TestIntegerDivision < Test::Unit::TestCase
 
  def test_standard_behaviour
    program = lambda { |x, y| x / y }
    assert_equal(5, RubyToRobust::Local.execute(program, [50, 10]))
    assert_equal(5, program[50, 10])
  end
 
  def test_hard_dbz
    program = lambda { |x, y| x / y }
    assert_raise(ZeroDivisionError) { program[1, 0] }
    assert_raise(ZeroDivisionError) { program[2, 0] }
    assert_raise(ZeroDivisionError) { program[10, 0] }
    assert_raise(ZeroDivisionError) { program[255, 0] }
  end

  def test_soft_dbz
    program = lambda { |x, y| x / y }
    assert_equal(0, RubyToRobust::Local.execute(program, [1, 0]))
    assert_equal(0, RubyToRobust::Local.execute(program, [2, 0]))
    assert_equal(0, RubyToRobust::Local.execute(program, [10, 0]))
    assert_equal(0, RubyToRobust::Local.execute(program, [255, 0]))
  end
 
end