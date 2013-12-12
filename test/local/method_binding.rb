require 'to_robust'
require 'test/unit'

module TestMethods
  def self.add(x,y); x+y; end
  def self.sub(x,y); x-y; end
  def self.mul(x,y); x*y; end
end
 
class TestMethodBinding < Test::Unit::TestCase
 
  def test_standard_bad_method_name
    assert_raise(NoMethodError) { TestMethods.ad(3,2) }
    assert_raise(NoMethodError) { TestMethods.addd(3,2) }
    assert_raise(NoMethodError) { TestMethods.su(3,2) }
    assert_raise(NoMethodError) { TestMethods.sab(3,2) }
    assert_raise(NoMethodError) { TestMethods.mula(3,2) }
    assert_raise(NoMethodError) { TestMethods.mu(3,2) }
  end

  def test_good_method_call
    
    # Without Local robustness.
    assert_equal(6, TestMethods.add(3,3))
    assert_equal(9, TestMethods.mul(3,3))
    assert_equal(0, TestMethods.sub(3,3))

    # Using Local robustness.
    assert_equal(6, RubyToRobust::Local.protected(TestMethods) { TestMethods.add(3,3) })
    assert_equal(9, RubyToRobust::Local.protected(TestMethods) { TestMethods.mul(3,3) })
    assert_equal(0, RubyToRobust::Local.protected(TestMethods) { TestMethods.sub(3,3) })

  end


  def test_soft_method_call

    # Enable local robustness.
    assert_equal(6, RubyToRobust::Local.protected(TestMethods) { TestMethods.ad(3,3) })
    assert_equal(9, RubyToRobust::Local.protected(TestMethods) { TestMethods.ml(3,3) })
    assert_equal(0, RubyToRobust::Local.protected(TestMethods) { TestMethods.sab(3,3) })

  end

end