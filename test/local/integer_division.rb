require 'to_robust'
require 'test/unit'
 
class TestIntegerDivision < Test::Unit::TestCase
 
  def test_standard_behaviour
    program = lambda { |x, y| x / y }
    assert_equal(5, ToRobust::Local.protected { program[50, 10] })
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
    assert_equal(0, ToRobust::Local.protected { program[1, 0] })
    assert_equal(0, ToRobust::Local.protected { program[2, 0] })
    assert_equal(0, ToRobust::Local.protected { program[10, 0] })
    assert_equal(0, ToRobust::Local.protected { program[255, 0] })
  end
 
end