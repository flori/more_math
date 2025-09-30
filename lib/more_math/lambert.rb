module MoreMath
  # Provides the Lambert W function implementation for solving equations of the
  # form x * e^x = y
  #
  # The Lambert W function is a special function that solves the implicit
  # equation x * e^x = y for x in terms of y. It has applications in various
  # fields including combinatorics, physics, and engineering problems involving
  # exponential growth and decay.
  module Lambert
    # Calculates the principal branch of the Lambert W function (W₀).
    #
    # The Lambert W function solves the equation: x * e^x = y
    #
    # @param y [Numeric] The input value for which to calculate W(y)
    # @param epsilon [Float] Convergence threshold for the root finding algorithm
    # @return [Float] The principal branch of the Lambert W function W(y)
    # @raise [Math::DomainError] When y < -1/e (function is undefined for real numbers)
    #
    # @example Calculate W(1)
    #   MoreMath::Lambert.lambert_w(1)  # => 0.5671432904097838
    #
    # @example Calculate W(0)
    #   MoreMath::Lambert.lambert_w(0)  # => 0.0
    #
    # @example Calculate W(-1/e)
    #   MoreMath::Lambert.lambert_w(-1.0 / Math::E)  # => -1.0
    #
    # @example Calculate W(100)
    #   MoreMath::Lambert.lambert_w(100)  # => 3.432480170522278
    def lambert_w(y, epsilon = 1E-16)
      # Handle special cases
      return 0.0 if y.zero?
      return Float::INFINITY if y.infinite?
      return -1.0 if (y - -1.0 / Math::E).abs < epsilon
      return 0 / 0.0 if y <= -1.0 / Math::E

      # Define the function f(x) = x * e^x - y
      func = ->(x) { x * Math.exp(x) - y }

      solver = MoreMath::NewtonBisection.new(&func)
      solver.solve(nil, 1 << 16, epsilon)
    end
  end
end
