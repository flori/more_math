require 'tins'

module MoreMath
  # Represents a histogram for visualizing data distributions
  #
  # The Histogram class provides functionality to create and display histograms
  # from sequences of numerical data. It divides the data into bins and counts
  # how many elements fall into each bin, then displays this information in a
  # readable format with optional UTF-8 bar characters.
  #
  # @example Creating a histogram
  #   sequence = [1, 2, 3, 4, 5, 1]
  #   hist = Histogram.new(sequence, bins: 3)
  #
  # @example Displaying a histogram
  #   hist.display($stdout, 80)
  class Histogram
    # Represents a single bin in a histogram with left boundary, right
    # boundary, and count.
    #
    # @!attribute [r] left
    #   @return [Float] The left boundary of the bin
    # @!attribute [r] right
    #   @return [Float] The right boundary of the bin
    # @!attribute [r] count
    #   @return [Integer] The number of elements in this bin
    Bin = Struct.new(:left, :right, :count)

    # Create a Histogram for the elements of +sequence+ with +bins+ bins.
    #
    # @param sequence [Enumerable] The sequence to build the histogram from
    # @param arg [Integer, Hash] Number of bins or hash with options like `:bins` and `:with_counts`
    # @option arg [Integer] :bins (10) Number of bins to use
    # @option arg [Boolean] :with_counts (false) Whether to display counts in output
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
    #
    # @return [Integer]
    attr_reader :bins

    # Return the computed histogram as an array of Bin objects.
    #
    # @return [Array<Bin>]
    def to_a
      @result
    end

    # Iterate over each bin in the histogram.
    #
    # @yield [Bin] each bin
    # @return [Array<Bin>]
    def each_bin(&block)
      @result.each(&block)
    end

    # Get an array of counts from each bin.
    #
    # @return [Array<Integer>]
    def counts
      each_bin.map(&:count)
    end

    # Display this histogram to +output+ using +width+ columns. Raises
    # ArgumentError if width < 15.
    #
    # @param output [IO] The output stream to write to (default: $stdout)
    # @param width [Integer, String] Width of the display; can be a percentage string like "90%"
    # @raise [ArgumentError] If width is less than 15
    # @return [self]
    def display(output = $stdout, width = 65)
      if width.is_a?(String) && width =~ /(.+)%\z/
        percentage = Float($1).clamp(0, 100)
        width = (terminal_width * (percentage / 100.0)).floor
      end
      width > 15 or raise ArgumentError, "width needs to be >= 15"
      for r in rows
        output << output_row(r, width)
      end
      output << "max_count=#{max_count}\n"
      self
    end

    # Get terminal width using Tins::Terminal.
    #
    # @return [Integer]
    def terminal_width
      Tins::Terminal.columns
    end

    # Get the maximum count in any bin.
    #
    # @return [Integer]
    def max_count
      counts.max
    end

    private

    # Generate UTF-8 bar character representation based on width.
    #
    # @param bar_width [Float] Width of the bar
    # @return [String]
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

    # Generate ASCII bar character representation based on width.
    #
    # @param bar_width [Float] Width of the bar
    # @return [String]
    def ascii_bar(bar_width)
      ?* * bar_width
    end

    # Determine if UTF-8 is enabled in the environment.
    #
    # @return [Boolean]
    def utf8?
      ENV['LANG'] =~ /utf-8\z/i
    end

    # Format a single row of histogram data for output.
    #
    # @param row [Array] A tuple containing [left, right, count]
    # @param width [Integer] Width of the bar display area
    # @return [String]
    def output_row(row, width)
      left, right, count = row
      if @with_counts
        output_row_with_count(left, right, count, width)
      else
        output_row_without_count(left, right, count, width)
      end
    end

    # Output a row with counts.
    #
    # @param left [Float] Left boundary of bin
    # @param right [Float] Right boundary of bin
    # @param count [Integer] Count in bin
    # @param width [Integer] Width of bar display area
    # @return [String]
    def output_row_with_count(left, right, count, width)
      width -= 15
      c = utf8? ? 2 : 1
      left_width = width - (counts.map { |x| x.to_s.size }.max + c)
      if left_width < 0
        left_width = width
      end
      factor    = left_width.to_f / max_count
      bar_width = (count * factor)
      bar = utf8? ? utf8_bar(bar_width) : ascii_bar(bar_width)
      max_count_length = max_count.to_s.size
      "%11.5f -|%#{-width + max_count_length}s%#{max_count_length}s\n" %
        [ (left + right) / 2.0, bar, count ]
    end

    # Output a row without counts.
    #
    # @param left [Float] Left boundary of bin
    # @param right [Float] Right boundary of bin
    # @param count [Integer] Count in bin
    # @param width [Integer] Width of bar display area
    # @return [String]
    def output_row_without_count(left, right, count, width)
      width -= 15
      left_width = width
      left_width < 0 and left_width = width
      factor    = left_width.to_f / max_count
      bar_width = (count * factor)
      bar = utf8? ? utf8_bar(bar_width) : ascii_bar(bar_width)
      "%11.5f -|%#{-width}s\n" % [ (left + right) / 2.0, bar ]
    end

    # Returns rows for display.
    #
    # @return [Array<Array>]
    def rows
      @result.reverse_each.map { |bin|
        [ bin.left, bin.right, bin.count ]
      }
    end

    # Computes the histogram and returns it as an array of tuples (l, c, r).
    #
    # @return [Array<Bin>]
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
