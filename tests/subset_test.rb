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

  def test_project
    a      = %i[ a b c d e ]
    subset = Subset.new(a.size, 23)
    assert_raises(ArgumentError) { subset.project a + %i[ f ] }
    (2 ** a.size).times do |i|
      subset  = Subset.new(a.size, i)
      projected = subset.project(a)
      assert_equal(projected, Subset.power_set(a)[i])
    end
  end
end
