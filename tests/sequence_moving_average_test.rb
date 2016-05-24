#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class SequenceMovingAverageTest < Test::Unit::TestCase
  include MoreMath

  def setup
    @seq = Sequence.new([ 3, 1, 7, 5, 6 ])
  end

  def test_moving_average_fail
    assert_raise(ArgumentError) { @seq.moving_average(0) }
    assert_raise(ArgumentError) { @seq.moving_average(-1) }
    assert_raise(ArgumentError) { @seq.moving_average(@seq.size + 1) }
  end

  def test_moving_average
    assert_equal @seq.elements.map(&:to_f),
      @seq.moving_average(1)
    assert_equal [ (3 + 1) / 2.0, (1 + 7) / 2.0, (7 + 5) / 2.0, (5 + 6) / 2.0 ],
      @seq.moving_average(2)
    assert_equal [ (3 + 1 + 7) / 3.0, (1 + 7 + 5) / 3.0, (7 + 5 + 6) / 3.0 ],
      @seq.moving_average(3)
    assert_equal [ (3 + 1 + 7 + 5) / 4.0, (1 + 7 + 5 + 6) / 4.0 ],
      @seq.moving_average(4)
    assert_equal [ @seq.mean ], @seq.moving_average(5)
  end
end

