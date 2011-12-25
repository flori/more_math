#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class DistributionTest < Test::Unit::TestCase
  include MoreMath

  def setup
    @td23 = TDistribution.new 23
    @td100 = TDistribution.new 100
    @chi23 = ChiSquareDistribution.new 23
    @chi100 = ChiSquareDistribution.new 100
  end

  def test_tdistribution
    xs = [ 75, 80, 85, 90, 95, 97.5, 99, 99.5, 99.75, 99.9, 99.95 ].map { |x|
      x / 100.0 }
    ys = [ 0.685, 0.858, 1.060, 1.319, 1.714, 2.069, 2.500, 2.807, 3.104,
      3.485, 3.767 ]
    xs.zip(ys) do |x, y|
      assert_in_delta y, @td23.inverse_probability(x), 1E-2
    end
    assert_equal @td23.inverse_probability(-0.1), -1 / 0.0
    assert_equal @td23.inverse_probability(1.1), 1 / 0.0
    ys = [ 0.677, 0.845, 1.042, 1.290, 1.660, 1.984, 2.364, 2.626, 2.871,
      3.174, 3.390 ]
    xs.zip(ys) do |x, y|
      assert_in_delta y, @td100.inverse_probability(x), 1E-2
    end
    assert_equal @td100.inverse_probability(-0.1), -1 / 0.0
    assert_equal @td100.inverse_probability(1.1), 1 / 0.0
  end

  def test_standard_normal_distribution
    std = STD_NORMAL_DISTRIBUTION
    ps = [ 0.001, 0.005, 0.010, 0.025, 0.050, 0.100 ]
    zs = [ -3.090, -2.576, -2.326, -1.960, -1.645, -1.282 ]
    ps.zip(zs) do |p, z|
      assert_in_delta z, std.inverse_probability(p), 1E-2
    end
    assert_equal std.inverse_probability(-0.1), -1 / 0.0
    assert_equal std.inverse_probability(1.1), 1 / 0.0
    ps.zip(zs) do |p, z|
      assert_in_delta(-z, std.inverse_probability(1 - p), 1E-2)
    end
    assert_in_delta 0, std.inverse_probability(0.5), 1E-6
  end

  def test_chisquaredistribution
    xs = [ 0.0, 1, 9.260, 11.689, 28.429, 32.007, 35.172, 38.076, 38.968, 41.638,
      44.181, 47.391, 49.728 ]
    ys = [ 0.0, 1.593887e-12, 0.004998304, 0.025006129, 0.800007427, 0.900002084, 0.949994698,
      0.975002306, 0.979998428, 0.989998939, 0.994999617, 0.997999729,
      0.998999930 ]
    xs.zip(ys) do |x, y|
      assert_in_delta y, @chi23.probability(x), 1E-6
      assert_in_delta x, @chi23.inverse_probability(y), 1E-6
    end
    assert_in_delta @chi23.probability(-0.1), 0.0, 1E-6
    ys = [ 0.0, 1.788777e-80, 6.705663e-34, 2.337654e-29, 1.321036e-13, 8.695875e-12,
      2.085529e-10, 2.691731e-09, 5.559949e-09, 4.192445e-08, 2.373762e-07,
      1.678744e-06, 6.034997e-06 ]
    xs.zip(ys) do |x, y|
      assert_in_delta y, @chi100.probability(x), 1E-6
      assert_in_delta x, @chi100.inverse_probability(y), 1E-6
    end
    assert_in_delta @chi100.probability(-0.1), 0.0, 1E-6
  end
end
