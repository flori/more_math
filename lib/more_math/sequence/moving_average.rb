module MoreMath
  class Sequence
    module MovingAverage
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
      alias moving_average simple_moving_average
    end
  end
end
