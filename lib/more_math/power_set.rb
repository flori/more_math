module MoreMath
  class PowerSet
    def initialize(array)
      @array = array
    end

    def each
      0.upto(2 ** @array.size - 1) do |x|
        a = []
        0.upto(@array.size - 1) do |i|
          x[i] == 1 and a << @array[i]
        end
        yield a
      end
    end
    include Enumerable
  end
end
