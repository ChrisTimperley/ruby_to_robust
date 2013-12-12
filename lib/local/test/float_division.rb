require 'to_robust'
require 'test/unit'
 
class TestFloatDivision < Test::Unit::TestCase
 
  def test_standard_behaviour
    program = lambda { |x, y| x / y }
    assert_equal(5.0, ToRobust::Local.protected { program[50.0, 10.0] })
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
    assert_equal(0.0, ToRobust::Local.protected { program[1.0, 0.0] })
    assert_equal(0.0, ToRobust::Local.protected { program[2.0, 0.0] })
    assert_equal(0.0, ToRobust::Local.protected { program[10.0, 0.0] })
    assert_equal(0.0, ToRobust::Local.protected { program[255.0, 0.0] })
  end
 
end