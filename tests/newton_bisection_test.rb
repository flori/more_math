#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class NewtonBisectionTest < Test::Unit::TestCase
  include MoreMath

  def test_bracket
    solver = NewtonBisection.new { |x| x ** 2 - 3 }
    assert_raises(ArgumentError) { solver.bracket(1..1) }
    assert_raises(ArgumentError) { solver.bracket(1..-1) }
    range = solver.bracket(0..0.1)
    assert_in_delta range.first, 0, 1E-6
    assert_in_delta range.last, 1.7576, 1E-6
    range = solver.bracket(2..3)
    assert_in_delta range.first, 0.4, 1E-6
    assert_in_delta range.last, 3, 1E-6
  end

  def test_zero
    solver = NewtonBisection.new { |x| x ** 2 - 3 }
    assert_in_delta 1.73205, solver.solve, 1E-6
    assert_in_delta(-1.73205, solver.solve(-5..-1), 1E-6)
    assert_in_delta 1.73205, solver.solve(solver.bracket(0..0.1)), 1E-6
    assert_in_delta 1.73205, solver.solve(solver.bracket(2..3)), 1E-6
  end
end
