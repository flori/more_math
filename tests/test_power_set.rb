#!/usr/bin/env ruby

require 'test/unit'
require 'more_math'

class TestPowerSet < Test::Unit::TestCase
  include MoreMath

  def test_empty_set
    assert_equal [[]], PowerSet.new([]).to_a
  end

  def test_one_element_set
    assert_equal [[], [1]], PowerSet.new([1]).to_a
  end

  def test_three_element_set
    assert_equal [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]],
      PowerSet.new([1, 2, 3]).to_a
  end
end
