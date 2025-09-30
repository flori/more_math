require 'test_helper'

class TestLambertW < Test::Unit::TestCase
  include MoreMath::Functions

  def setup
    @delta = 1e-10
  end

  def test_lambert_w_zero
    result = lambert_w(0)
    assert_in_delta(0.0, result, @delta)
  end

  def test_lambert_w_infinity
    result = lambert_w(Float::INFINITY)
    assert_equal(Float::INFINITY, result)
  end

  def test_lambert_w_negative_one_over_e
    result = lambert_w(-1.0 / Math::E)
    assert_in_delta(-1.0, result, @delta)
  end

  def test_lambert_w_positive_value
    result = lambert_w(1)
    expected = 0.5671432904097838
    assert_in_delta(expected, result, @delta)
  end

  def test_lambert_w_large_positive_value
    result = lambert_w(100)
    expected = 3.3856301402900501
    assert_in_delta(expected, result, @delta)
  end

  def test_lambert_w_small_positive_value
    result = lambert_w(0.1)
    expected = 0.091276527160862
    assert_in_delta(expected, result, @delta)
  end

  def test_lambert_w_verify_solution_property
    y = 5.0
    w = lambert_w(y)
    result = w * Math.exp(w)
    assert_in_delta(y, result, @delta)
  end

  def test_lambert_w_verify_solution_property_large
    y = 1000.0
    w = lambert_w(y)
    result = w * Math.exp(w)
    assert_in_delta(y, result, @delta)
  end

  def test_lambert_w_domain_error
    result = lambert_w(-1.0 / Math::E - 0.1)
    assert(result.nan?)
  end

  def test_lambert_w_edge_case
    y = 1e-10
    w = lambert_w(y)
    result = w * Math.exp(w)
    assert_in_delta(y, result, @delta)
  end
end
