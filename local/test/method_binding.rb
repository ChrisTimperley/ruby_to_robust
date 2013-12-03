require_relative '../../init.rb'
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
    assert_equal(6, TestMethods.add(3,3))
    assert_equal(9, TestMethods.mul(3,3))
    assert_equal(0, TestMethods.sub(3,3))

    # Enable local robustness.
    RubyToRobust::Local.prepare(TestMethods)
    RubyToRobust::Local.enable!
    assert_equal(6, TestMethods.add(3,3))
    assert_equal(9, TestMethods.mul(3,3))
    assert_equal(0, TestMethods.sub(3,3))
    RubyToRobust::Local.disable!
  end


  def test_soft_method_call
    # Enable local robustness.
    RubyToRobust::Local.prepare(TestMethods)
    RubyToRobust::Local.enable!
    assert_equal(6, TestMethods.ad(3,3))
    assert_equal(9, TestMethods.ml(3,3))
    assert_equal(0, TestMethods.sab(3,3))
    RubyToRobust::Local.disable!
  end

end