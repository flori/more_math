#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class SubsetTest < Test::Unit::TestCase
  include MoreMath

  def test_empty_set
    assert_equal [[]], Subset.for([]).map(&:value)
  end

  def test_one_element_set
    assert_equal [[], [1]], Subset.for([1]).map(&:value)
  end

  def test_three_element_set
    expected = [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
    assert_equal expected, Subset.for([1, 2, 3]).map(&:value)
    assert_equal expected, Subset.power_set([1, 2, 3])
  end
end
