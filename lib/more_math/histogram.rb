require 'more_math'

module MoreMath
  # A histogram gives an overview of a sequence's elements.
  class Histogram
    # Create a Histogram for the elements of +sequence+ with +bins+ bins.
    def initialize(sequence, bins = 10)
      @sequence = sequence
      @bins = bins
      @result = compute
    end

    # Number of bins for this Histogram.
    attr_reader :bins

    # Return the computed histogram as an array of arrays.
    def to_a
      @result
    end

    # Display this histogram to +output+, +width+ is the parameter for
    # +prepare_display+
    def display(output = $stdout, width = 50)
      d = prepare_display(width)
      for l, bar, r in d
        output << "%11.5f -|%s\n" % [ (l + r) / 2.0, "*" * bar ]
      end
      self
    end

    private

    # Returns an array of tuples (l, c, r) where +l+ is the left bin edge, +c+
    # the +width+-normalized frequence count value, and +r+ the right bin
    # edge. +width+ is usually an integer number representing the width of a
    # histogram bar.
    def prepare_display(width)
      r = @result.reverse
      factor = width.to_f / (r.transpose[1].max)
      r.map { |l, c, r| [ l, (c * factor).round, r ] }
    end

    # Computes the histogram and returns it as an array of tuples (l, c, r).
    def compute
      @sequence.empty? and return []
      last_r = -Infinity
      min = @sequence.min
      max = @sequence.max
      step = (max - min) / bins.to_f
      Array.new(bins) do |i|
        l = min + i  * step
        r = min + (i + 1) * step
        c = 0
        @sequence.each do |x|
          x > last_r and (x <= r || i == bins - 1) and c += 1
        end
        last_r = r
        [ l, c, r ]
      end
    end
  end
end
