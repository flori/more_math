#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'
require 'stringio'

class HistogramTest < Test::Unit::TestCase
  include MoreMath

  def test_histogram
    sequence = Sequence.new [ 1, 2, 3, 0, 2 ]
    histogram = Histogram.new sequence, 3
    assert_equal [ [0.0, 1.0, 2], [1.0, 2.0, 2], [2.0, 3.0, 1] ],
      histogram.each_bin.map(&:to_a)
  end

  def test_histogram_display
    sequence = Sequence.new [ 1, 2, 3, 0, 2 ]
    histogram = Histogram.new sequence, 3
    assert_equal [[2.0, 3.0, 1], [1.0, 2.0, 2], [0.0, 1.0, 2]],
      histogram.instance_eval { rows }
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
        2.50000 -|*************************
        1.50000 -|**************************************************
        0.50000 -|**************************************************
    max_count=2
    end
  end

  def test_histogram_display_with_counts
    sequence = Sequence.new [ 1, 2, 3, 0, 2 ]
    histogram = Histogram.new sequence, with_counts: true, bins: 3
    assert_equal [[2.0, 3.0, 1], [1.0, 2.0, 2], [0.0, 1.0, 2]],
      histogram.instance_eval { rows }
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
        2.50000 -|************************                         1
        1.50000 -|************************************************ 2
        0.50000 -|************************************************ 2
    max_count=2
    end
  end
end
