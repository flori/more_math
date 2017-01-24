module MoreMath
  # A histogram gives an overview of a sequence's elements.
  class Histogram
    Bin = Struct.new(:left, :right, :count)

    # Create a Histogram for the elements of +sequence+ with +bins+ bins.
    def initialize(sequence, bins = 10)
      @sequence = sequence
      @bins = bins
      @result = compute
    end

    # Number of bins for this Histogram.
    attr_reader :bins

    # Return the computed histogram as an array of Bin objects.
    def to_a
      @result
    end

    def each_bin(&block)
      @result.each(&block)
    end

    def counts
      each_bin.map(&:count)
    end

    # Display this histogram to +output+, +width+ is the parameter for
    # +prepare_display+
    def display(output = $stdout, width = 50)
      d = prepare_display(width)
      for l, bar, r in d
        output << "%11.5f -|%s\n" % [ (l + r) / 2.0, "*" * bar ]
      end
      output << "max_count=#{max_count}\n"
      self
    end

    def max_count
      counts.max
    end

    private

    # Returns an array of tuples (l, c, r) where +l+ is the left bin edge, +c+
    # the +width+-normalized frequence count value, and +r+ the right bin
    # edge. +width+ is usually an integer number representing the width of a
    # histogram bar.
    def prepare_display(width)
      factor = width.to_f / max_count
      @result.reverse_each.map { |bin| [ bin.left, (bin.count * factor).round, bin.right ] }
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
        Bin.new(l, r, c)
      end
    end
  end
end
