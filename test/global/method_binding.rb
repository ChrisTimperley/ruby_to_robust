# encoding: utf-8

require_relative 'base'
require_relative '../../lib/to_robust'

module TestMethods
  def self.add(x,y); x+y; end
  def self.sub(x,y); x-y; end
  def self.mul(x,y); x*y; end
end
 
class TestMethodBinding < GlobalTestCase
 
  def test_standard_bad_method_name
    assert_raise(NoMethodError) { TestMethods.ad(3,2) }
    assert_raise(NoMethodError) { TestMethods.addd(3,2) }
    assert_raise(NoMethodError) { TestMethods.su(3,2) }
    assert_raise(NoMethodError) { TestMethods.sab(3,2) }
    assert_raise(NoMethodError) { TestMethods.mula(3,2) }
    assert_raise(NoMethodError) { TestMethods.mu(3,2) }
  end

  def test_good_method_call
    
    # Without Global robustness.
    assert_equal(6, TestMethods.add(3,3))
    assert_equal(9, TestMethods.mul(3,3))
    assert_equal(0, TestMethods.sub(3,3))

    # Using Global robustness.
    p1 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.add(x, y)')
    p2 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.mul(x, y)')
    p3 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.sub(x, y)')
    assert_equal(6, p1[3, 3])
    assert_equal(9, p2[3, 3])
    assert_equal(0, p3[3, 3])

  end


  def test_soft_method_call

    p1 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.ad(x, y)')
    p2 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.ml(x, y)')
    p3 = ToRobust::Global::RobustLambda.new(['x', 'y'], 'TestMethods.sab(x, y)')
    assert_equal(6, p1[3, 3])
    assert_equal(9, p2[3, 3])
    assert_equal(0, p3[3, 3])

  end

end
