#!/usr/bin/env ruby

require 'test/unit'
require 'more_math'
require 'stringio'

class TestHistogram < Test::Unit::TestCase
  include MoreMath

  def test_histogram
    sequence = Sequence.new [ 1, 2, 3, 0, 2 ]
    histogram = Histogram.new sequence, 3
    assert_equal [ [0.0, 2, 1.0], [1.0, 2, 2.0], [2.0, 1, 3.0] ],
      histogram.to_a
  end

  def test_histogram_display
    sequence = Sequence.new [ 1, 2, 3, 0, 2 ]
    histogram = Histogram.new sequence, 3
    assert_equal [[2.0, 25, 3.0], [1.0, 50, 2.0], [0.0, 50, 1.0]],
      histogram.instance_eval { prepare_display(50) }
    output = StringIO.new
    histogram.display output
    output_expected =
      "    2.50000 -|*************************\n    1.50000 -|*******************************"\
      "*******************\n    0.50000 -|**************************************************\n"
    assert_equal output_expected, output.string
  end
end
