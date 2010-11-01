#!/usr/bin/env ruby

require 'test/unit'
require 'more_math'

class TestContinuedFraction < Test::Unit::TestCase
  include MoreMath

  def setup
    @none1 = ContinuedFraction.for_a proc {}
    @none2 = ContinuedFraction.for_a {}
    @phi = ContinuedFraction.new
    @finite = ContinuedFraction.for_a [3, 4, 12, 3, 1]
    @sqrt_2 = ContinuedFraction.for_a { |n| n == 0 ? 1 : 2 }
    @pi_finite = ContinuedFraction.for_a [3, 7, 15, 1, 292, 1, 1, 1, 2]
    @e = ContinuedFraction.for_a { |n| (n + 1) }.for_b { |n| (n + 1) }
    @a113011 = ContinuedFraction.for_a { |n| 2 * n + 1 }.for_b { |n| 2 * n }
    @a073333 = ContinuedFraction.for_a { |n| n }.for_b { |n| n }
    @atan = ContinuedFraction.for_a do |n, x|
      n == 0 ? 0 : 2 * n - 1
    end.for_b do |n, x|
      n <= 1 ? x : ((n - 1) * x) ** 2
    end
    @pi = lambda { 4 * @atan[1] }
  end

  def test_continued_fractions
    assert @none1[1].nan?
    assert @none2[1].nan?
    assert_in_delta 1.618033, @phi[], 1E-6
    assert_in_delta 3.245, @finite[], 1E-4
    assert_in_delta Math.sqrt(2), @sqrt_2[], 1E-10
    assert_in_delta Math::PI, @pi_finite[], 1E-10
    assert_in_delta Math::E, 1 + @e[], 1E-10
    assert_in_delta 1.541494, @a113011[], 1E-6
    assert_in_delta 0.581976, @a073333[], 1E-6
    assert_in_delta Math.atan(0.5), @atan[0.5], 1E-10
    assert_in_delta Math::PI, @pi[], 1E-10
  end
end
