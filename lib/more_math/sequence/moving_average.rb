module MoreMath
  class Sequence
    # Module containing moving average calculation methods
    #
    # Provides simple moving average functionality for sequence analysis and
    # time series data.
    module MovingAverage
      # Calculates a simple moving average for the sequence
      #
      # A simple moving average is calculated by taking the arithmetic mean of
      # a specified number of consecutive elements in the sequence.
      #
      # @example Basic usage
      #   sequence = Sequence.new([1, 2, 3, 4, 5])
      #   sequence.simple_moving_average(3) # => [2.0, 3.0, 4.0]
      #
      # @example With alias usage
      #   sequence = Sequence.new([1, 2, 3, 4, 5])
      #   sequence.moving_average(2) # => [1.5, 2.5, 3.5, 4.5]
      #
      # @param n [Integer] The window size for the moving average (must be >= 1)
      # @return [Array<Float>] Array of moving averages, where each element is
      #   the mean of n consecutive elements from the original sequence
      # @raise [ArgumentError] If n < 1 or n > number of elements in the sequence
      #
      # @note The result array will contain (elements.size - n + 1) elements
      # @note Each moving average is calculated as the arithmetic mean of n
      #   consecutive elements
      def simple_moving_average(n)
        n < 1 and raise ArgumentError, 'n < 1, has to be >= 1'
        n <= @elements.size or raise ArgumentError,
          'n > #elements, has to be <= #elements'
        avg = []
        0.upto(@elements.size - n) do |i|
          sum = 0.0
          i.upto(i + n - 1) do |j|
            sum += @elements[j].to_f
          end
          avg << sum / n
        end
        avg
      end

      # Alias for {simple_moving_average}
      alias moving_average simple_moving_average
    end
  end
end
