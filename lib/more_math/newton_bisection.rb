require 'more_math/exceptions'

module MoreMath
  # This class is used to find the root of a function with Newton's bisection
  # method.
  #
  # The NewtonBisection class implements a hybrid root-finding algorithm that
  # combines elements of both Newton-Raphson and bisection methods. It starts
  # by attempting to bracket a root using a scaling factor, then uses a
  # bisection approach to converge on the solution.
  #
  # @example Finding a root using Newton's bisection method
  #   # Define a function to find roots for (e.g., x^2 - 4 = 0)
  #   func = ->(x) { x ** 2 - 4 }
  #
  #   # Create a NewtonBisection instance
  #   solver = MoreMath::NewtonBisection.new(&func)
  #
  #   # Find the root in a given range
  #   root = solver.solve(1..3)
  #   puts root  # => 2.0 (approximately)
  #
  # @example Finding a root with automatic bracketing
  #   func = ->(x) { Math.sin(x) }
  #   solver = MoreMath::NewtonBisection.new(&func)
  #
  #   # Let the solver automatically find a bracket
  #   root = solver.solve
  #   puts root  # => approximately 3.14159 (π)
  class NewtonBisection
    include MoreMath::Exceptions

    # Creates a NewtonBisection instance for +function+, a one-argument block.
    #
    # @param function [Proc] A one-argument block that represents the function
    #   to find roots for. The function should return a numeric value.
    # @example Creating a solver with a lambda
    #   func = ->(x) { x**2 - 4 }
    #   solver = MoreMath::NewtonBisection.new(&func)
    def initialize(&function)
      @function = function
    end

    # The function, passed into the constructor.
    #
    # @return [Proc] The function used for root finding
    attr_reader :function

    # Return a bracket around a root, starting from the initial +range+.
    #
    # This method attempts to find an interval that brackets a root by
    # expanding the initial range using a scaling factor. It uses the property
    # that if f(x1) and f(x2) have opposite signs, there must be at least one
    # root in the interval [x1, x2].
    #
    # @param range [Range] Initial range to search for a bracket (default: -1..1)
    # @param n [Integer] Maximum number of iterations to attempt bracketing (default: 50)
    # @param factor [Float] Scaling factor for expanding the search range (default: 1.6)
    # @return [Range, nil] A range that brackets a root, or nil if no bracket
    #   could be found within the specified iterations and factor
    # @raise [ArgumentError] If the initial range is invalid (x1 >= x2)
    # @example Finding a bracket for sin(x) function
    #   func = ->(x) { Math.sin(x) }
    #   solver = MoreMath::NewtonBisection.new(&func)
    #   bracket = solver.bracket(2..4)
    #   # Returns range that brackets root near π ≈ 3.14
    def bracket(range = -1..1, n = 50, factor = 1.6)
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
      nil
    end

    # Find the root of function in +range+ and return it.
    #
    # This method implements a bisection algorithm to find the root within
    # the specified range. It uses a binary search approach, repeatedly halving
    # the interval until convergence is achieved or maximum iterations are reached.
    #
    # @param range [Range] The range in which to search for a root (optional)
    #   If nil, attempts to automatically bracket the root first
    # @param n [Integer] Maximum number of iterations (default: 2^16)
    # @param epsilon [Float] Convergence threshold (default: 1E-16)
    # @return [Float] The approximate root value
    # @raise [ArgumentError] If the initial range is invalid or no bracket is found
    # @raise [MoreMath::Exceptions::DivergentException] If no root can be found
    #   within the specified iterations or if convergence fails
    # @example Solving x^2 - 4 = 0 with explicit range
    #   func = ->(x) { x**2 - 4 }
    #   solver = MoreMath::NewtonBisection.new(&func)
    #   root = solver.solve(1..3)  # Finds root near +2.0
    #   puts root  # => 2.0
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
