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
    def histogram.utf8?
      false
    end
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
    def histogram.utf8?
      false
    end
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

  def test_histogram_display_with_counts_lots
    srand 1337
    sequence = Sequence.new 1000.times.map { rand(10) * rand(10) }
    histogram = Histogram.new sequence, with_counts: true, bins: 3
    def histogram.utf8?
      false
    end
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
       67.50000 -|*****                                           81
       40.50000 -|*************                                  206
       13.50000 -|********************************************** 713
    max_count=713
    end
  end

  def test_histogram_display_utf8
    srand 1337
    sequence = Sequence.new 1000.times.map { rand(10) }
    histogram = Histogram.new sequence, 3
    def histogram.utf8?
      true
    end
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
        7.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿               
        4.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇                
        1.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ 
    max_count=420
    end
  end

  def test_histogram_display_with_counts_utf8
    srand 1337
    sequence = Sequence.new 1000.times.map { rand(10) }
    histogram = Histogram.new sequence, with_counts: true, bins: 3
    def histogram.utf8?
      true
    end
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
        7.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇               295
        4.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇                285
        1.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  420
    max_count=420
    end
  end

  def test_histogram_display_with_counts_utf8_zero
    srand 1337
    sequence = Sequence.new 1000.times.map { rand(10) * rand(10) }
    histogram = Histogram.new sequence, with_counts: true, bins: 3
    def histogram.utf8?
      true
    end
    output = StringIO.new
    histogram.display output
    assert_equal <<~end, output.string
       67.50000 -|⣿⣿⣿⣿⣿                                           81
       40.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                                  206
       13.50000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  713
    max_count=713
    end
  end

  private

  def output_histogram(histogram)
    $stdout.puts
    histogram.display $stdout
    $stdout.puts
  end
end
