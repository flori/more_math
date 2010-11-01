require 'more_math/exceptions'
require 'more_math'

module MoreMath
  # This class is used to find the root of a function with Newton's bisection
  # method.
  class NewtonBisection
    include MoreMath::Exceptions

    # Creates a NewtonBisection instance for +function+, a one-argument block.
    def initialize(&function)
      @function = function
    end

    # The function, passed into the constructor.
    attr_reader :function

    # Return a bracket around a root, starting from the initial +range+. The
    # method returns nil, if no such bracket around a root could be found after
    # +n+ tries with  the scaling +factor+.
    def bracket(range = -1..1, n = 50, factor =  1.6)
      x1, x2 = range.first.to_f, range.last.to_f
      x1 >= x2 and raise ArgumentError, "bad initial range #{range}"
      f1, f2 = @function[x1], @function[x2]
      n.times do
        f1 * f2 < 0 and return x1..x2
        if f1.abs < f2.abs
          f1 = @function[x1 += factor * (x1 - x2)]
        else
          f2 = @function[x2 += factor * (x2 - x1)]
        end
      end
      return
    end

    # Find the root of function in +range+ and return it. The method raises a
    # DivergentException, if no such root could be found after +n+ tries and in
    # the +epsilon+ environment.
    def solve(range = nil, n = 1 << 16, epsilon = 1E-16)
      if range
        x1, x2 = range.first.to_f, range.last.to_f
        x1 >= x2 and raise ArgumentError, "bad initial range #{range}"
      elsif range = bracket
        x1, x2 = range.first, range.last
      else
        raise DivergentException, "bracket could not be determined"
      end
      f = @function[x1]
      fmid = @function[x2]
      f * fmid >= 0 and raise DivergentException, "root must be bracketed in #{range}"
      root = if f < 0
               dx = x2 - x1
               x1
             else
               dx = x1 - x2
               x2
             end
      n.times do
        fmid = @function[xmid = root + (dx *= 0.5)]
        fmid < 0 and root = xmid
        dx.abs < epsilon or fmid == 0 and return root
      end
      raise DivergentException, "too many iterations (#{n})"
    end
  end
end
