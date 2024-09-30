module MoreMath
  # A histogram gives an overview of a sequence's elements.
  class Histogram
    Bin = Struct.new(:left, :right, :count)

    # Create a Histogram for the elements of +sequence+ with +bins+ bins.
    def initialize(sequence, arg = 10)
      @with_counts = false
      if arg.is_a?(Hash)
        bins = arg.fetch(:bins, 10)
        wc = arg[:with_counts] and @with_counts = wc
      else
        bins = arg
      end
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
      width >= 1 or raise ArgumentError, "width needs to be >= 1"
      for r in rows
        output << output_row(r, width)
      end
      output << "max_count=#{max_count}\n"
      self
    end

    def max_count
      counts.max
    end

    private

    def utf8_bar(bar_width)
      fract = bar_width - bar_width.floor
      bar   = ?⣿ * bar_width.floor
      if fract > 0.5
        bar << ?⡇
      else
        bar << ' '
      end
      bar
    end

    def ascii_bar(bar_width)
      bar = ?* * bar_width
    end

    def utf8?
      ENV['LANG'] =~ /utf-8\z/i
    end

    def output_row(row, width)
      left, right, count = row
      if @with_counts
        c = utf8? ? 2 : 1
        left_width = width - (counts.map { |x| x.to_s.size }.max + c)
      else
        left_width = width
      end
      if left_width < 0
        left_width = width
      end
      factor    = left_width.to_f / max_count
      bar_width = (count * factor)
      bar = utf8? ? utf8_bar(bar_width) : ascii_bar(bar_width)
      if @with_counts
        if utf8?
          if bar[-1] == ' '
            bar += count.to_s.rjust(width - bar_width - 1)
          else
            bar += count.to_s.rjust(width - bar_width)
          end
        else
          bar += count.to_s.rjust(width - bar_width)
        end
      end
      "%11.5f -|%s\n" % [ (left + right) / 2.0, bar ]
    end

    def rows
      @result.reverse_each.map { |bin|
        [ bin.left, bin.right, bin.count ]
      }
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
