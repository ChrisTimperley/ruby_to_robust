require_relative '../local/init.rb'
require 'test/unit'
 
class TestFloatDivision < Test::Unit::TestCase
 
  def test_standard_behaviour
    program = lambda { |x, y| x / y }
    assert_equal(0.5, RubyToRobust::Local.execute(program, [1.0, 2.0]))
    assert_equal(0.5, program[1.0, 2.0])
  end
 
  def test_hard_dbz
    program = lambda { |x, y| x / y }
    assert_equal(Float::INFINITY, program[1.0, 0.0])
  end

  def test_soft_dbz
    program = lambda { |x, y| x / y }
    assert_equal(0.0, RubyToRobust::Local.execute(program, [1.0, 0.0]))
  end
 
end