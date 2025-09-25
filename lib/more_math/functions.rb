require 'more_math/entropy'

module MoreMath
  # Provides mathematical functions and special functions for scientific computing.
  #
  # This module includes implementations of various mathematical functions commonly
  # used in statistics, numerical analysis, and scientific computing. It extends
  # Ruby's built-in Math module with additional functionality and provides
  # specialized implementations for better accuracy and performance.
  #
  # @example Using mathematical functions
  #   include MoreMath::Functions
  #
  #   # Gamma function calculation
  #   gamma(5)        # => ~ 24.0 (4!)
  #   gamma(0.5)      # => ~ 1.772 (sqrt(pi))
  #
  #   # Beta function calculation
  #   beta(2, 3)      # => ~ 0.083 (B(2,3) = Gamma(2)*Gamma(3)/Gamma(5))
  #
  #   # Error function
  #   erf(1)          # => ~ 0.843
  module Functions
    module_function

    include Math
    extend Math

    if Math.respond_to?(:lgamma)
      # The log_gamma function extends the factorial to real and complex
      # numbers. For positive integers, Gamma(n) = (n-1)!.
      #
      # @param x [Numeric] The input value for which to calculate log_gamma
      # @return [Float] Natural logarithm of the gamma function at x
      # @raise [ZeroDivisionError] When x is zero or a negative integer
      def log_gamma(x)
        lgamma(x).first
      end
    else
      # Returns the natural logarithm of Euler gamma function value for +x+
      # using the Lanczos approximation if not provided by Ruby.
      def log_gamma(x)
        x = x.to_f
        if x.nan? || x <= 0
          0 / 0.0
        else
          sum = 0.0
          lc = Constants::FunctionsConstants::LANCZOS_COEFFICIENTS
          half_log_2_pi = Constants::FunctionsConstants::HALF_LOG_2_PI
          (lc.size - 1).downto(1) do |i|
            sum += lc[i] / (x + i)
          end
          sum += lc[0]
          tmp = x + 607.0 / 128 + 0.5
          (x + 0.5) * log(tmp) - tmp + half_log_2_pi + log(sum / x)
        end
      rescue Errno::ERANGE, Errno::EDOM
        0 / 0.0
      end
    end

    # Returns the value of the gamma function, extended to a negative domain.
    #
    # The gamma function is defined for all complex numbers except non-positive integers.
    # For positive real numbers, it extends the factorial: Gamma(n) = (n-1)!
    #
    # @param x [Numeric] The input value for which to calculate gamma
    # @return [Float] The gamma function value at x
    # @raise [ZeroDivisionError] When x is a non-positive integer
    def gamma(x)
      if x < 0.0
        return PI / (sin(PI * x) * exp(log_gamma(1 - x)))
      else
        exp(log_gamma(x))
      end
    end

    # Returns the natural logarithm of the beta function value for +(a, b)+.
    #
    # The beta function is defined as B(a,b) = Gamma(a)*Gamma(b)/Gamma(a+b)
    # and is commonly used in statistics and probability theory.
    #
    # @param a [Numeric] First parameter of the beta function
    # @param b [Numeric] Second parameter of the beta function
    # @return [Float] Natural logarithm of the beta function at (a,b)
    def log_beta(a, b)
      log_gamma(a) + log_gamma(b) - log_gamma(a + b)
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    # Returns the value of the beta function for +(a, b)+, +a > 0, b > 0'.
    #
    # The beta function B(a,b) = Gamma(a)*Gamma(b)/Gamma(a+b) is used in
    # statistical distributions and probability theory.
    #
    # @param a [Numeric] First parameter (must be > 0)
    # @param b [Numeric] Second parameter (must be > 0)
    # @return [Float] The beta function value at (a,b)
    def beta(a, b)
      if a > 0 && b > 0
        exp(log_beta(a, b))
      else
        0.0 / 0
      end
    end

    # Return an approximation value of Euler's regularized beta function for
    # +x+, +a+, and +b+ with an error <= +epsilon+, but only iterate
    # +max_iterations+-times.
    #
    # The regularized incomplete beta function I_x(a,b) = B(x;a,b)/B(a,b)
    # is used in statistics to compute probabilities for the beta distribution.
    #
    # @param x [Numeric] The upper limit of integration (0 <= x <= 1)
    # @param a [Numeric] First shape parameter (a > 0)
    # @param b [Numeric] Second shape parameter (b > 0)
    # @param epsilon [Float] Convergence tolerance (default: 1E-16)
    # @param max_iterations [Integer] Maximum number of iterations (default: 65536)
    # @return [Float] Regularized incomplete beta function value
    def beta_regularized(x, a, b, epsilon: 1E-16, max_iterations: 1 << 16)
      x, a, b = x.to_f, a.to_f, b.to_f
      case
      when a.nan? || b.nan? || x.nan? || a <= 0 || b <= 0 || x < 0 || x > 1
        0 / 0.0
      when x > (a + 1) / (a + b + 2)
        1 - beta_regularized(1 - x, b, a, epsilon: epsilon, max_iterations: max_iterations)
      else
        fraction = ContinuedFraction.for_b do |n, y|
          if n % 2 == 0
            m = n / 2.0
            (m * (b - m) * y) / ((a + (2 * m) - 1) * (a + (2 * m)))
          else
            m = (n - 1) / 2.0
            -((a + m) * (a + b + m) * y) / ((a + 2 * m) * (a + 2 * m + 1))
          end
        end
        exp(a * log(x) + b * log(1.0 - x) - log(a) - log_beta(a, b)) /
          fraction[x, epsilon: epsilon, max_iterations: max_iterations]
      end
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    # Return an approximation of the regularized gammaP function for +x+ and
    # +a+ with an error of <= +epsilon+, but only iterate
    # +max_iterations+-times.
    #
    # The regularized lower incomplete gamma function P(a,x) = γ(a,x)/Γ(a)
    # where γ(a,x) is the lower incomplete gamma function. This is used in
    # statistics to compute probabilities for the gamma distribution.
    #
    # @param x [Numeric] Upper limit of integration (x >= 0)
    # @param a [Numeric] Shape parameter (a > 0)
    # @param epsilon [Float] Convergence tolerance (default: 1E-16)
    # @param max_iterations [Integer] Maximum number of iterations (default: 65536)
    # @return [Float] Regularized lower incomplete gamma function value
    def gammaP_regularized(x, a, epsilon: 1E-16, max_iterations: 1 << 16)
      x, a = x.to_f, a.to_f
      case
      when a.nan? || x.nan? || a <= 0 || x < 0
        0 / 0.0
      when x == 0
        0.0
      when 1 <= a && a < x
        1 - gammaQ_regularized(x, a, epsilon: epsilon, max_iterations: max_iterations)
      else
        n = 0
        an = 1 / a
        sum = an
        while an.abs > epsilon && n < max_iterations
          n += 1
          an *= x / (a + n)
          sum += an
        end
        if n >= max_iterations
          raise Errno::ERANGE
        else
          exp(-x + a * log(x) - log_gamma(a)) * sum
        end
      end
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    # Return an approximation of the regularized gammaQ function for +x+ and
    # +a+ with an error of <= +epsilon+, but only iterate
    # +max_iterations+-times.
    #
    # The regularized upper incomplete gamma function Q(a,x) = Γ(a,x)/Γ(a)
    # where Γ(a,x) is the upper incomplete gamma function. This is used in
    # statistics to compute probabilities for the gamma distribution.
    #
    # @param x [Numeric] Upper limit of integration (x >= 0)
    # @param a [Numeric] Shape parameter (a > 0)
    # @param epsilon [Float] Convergence tolerance (default: 1E-16)
    # @param max_iterations [Integer] Maximum number of iterations (default: 65536)
    # @return [Float] Regularized upper incomplete gamma function value
    def gammaQ_regularized(x, a, epsilon: 1E-16, max_iterations: 1 << 16)
      x, a = x.to_f, a.to_f
      case
      when a.nan? || x.nan? || a <= 0 || x < 0
        0 / 0.0
      when x == 0
        1.0
      when a > x || a < 1
        1 - gammaP_regularized(x, a, epsilon: epsilon, max_iterations: max_iterations)
      else
        fraction = ContinuedFraction.for_a do |n, y|
          (2 * n + 1) - a + y
        end.for_b do |n, y|
          n * (a - n)
        end
        exp(-x + a * log(x) - log_gamma(a)) *
          fraction[x, epsilon: epsilon, max_iterations: max_iterations] ** -1
      end
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    unless Math.respond_to?(:erf)
      # Returns an approximate value for the error function's value for +x+
      # unless provided by Ruby.
      #
      # The error function erf(x) = (2/sqrt(pi)) * ∫₀ˣ e^(-t²) dt is used in probability,
      # statistics, and partial differential equations.
      #
      # @param x [Numeric] Input value
      # @return [Float] Error function value at x
      def erf(x)
        erf_a = MoreMath::Constants::FunctionsConstants::ERF_A
        r = sqrt(1 - exp(-x ** 2 * (4 / Math::PI + erf_a * x ** 2) / (1 + erf_a * x ** 2)))
        x < 0 ? -r : r
      end
    end

    unless Math.respond_to?(:erfc)
      # Returns the complementary error function value for +x+ unless provided
      # by Ruby.
      #
      # The complementary error function erfc(x) = 1 - erf(x) is used in probability
      # and statistics when computing tail probabilities.
      #
      # @param x [Numeric] Input value
      # @return [Float] Complementary error function value at x
      def erfc(x)
        1.0 - erf(x)
      end
    end

    # Computes the ceiling of the base +b+ logarithm of +n+.
    #
    # Returns the smallest integer k such that b^k >= n.
    #
    # @param n [Integer] The number to compute log for (must be > 0)
    # @param b [Integer] The base of the logarithm (must be > 1)
    # @return [Integer] Ceiling of log_b(n)
    # @raise [ArgumentError] If n <= 0 or b <= 1
    def log_ceil(n, b = 2)
      raise ArgumentError, "n is required to be > 0" unless n > 0
      raise ArgumentError, "b is required to be > 1" unless b > 1
      e, result = 1, 0
      until e >= n
        e *= b
        result += 1
      end
      result
    end

    # Computes the floor of the base +b+ logarithm of +n+.
    #
    # Returns the largest integer k such that b^k <= n.
    #
    # @param n [Integer] The number to compute log for (must be > 0)
    # @param b [Integer] The base of the logarithm (must be > 1)
    # @return [Integer] Floor of log_b(n)
    # @raise [ArgumentError] If n <= 0 or b <= 1
    def log_floor(n, b = 2)
      raise ArgumentError, "n is required to be > 0" unless n > 0
      raise ArgumentError, "b is required to be > 1" unless b > 1
      e, result = 1, 0
      until e * b > n
        e *= b
        result += 1
      end
      result
    end

    # Returns the base +b+ logarithm of the number +x+. +b+ defaults to base
    # 2, binary logarithm.
    #
    # @param x [Numeric] The number to compute log for (must be > 0)
    # @param b [Numeric] The base of the logarithm (default: 2)
    # @return [Float] Logarithm of x in base b
    def logb(x, b = 2)
      Math.log(x) / Math.log(b)
    end

    # Returns Cantor's tuple function for the tuple +*xs+ (the size must be at
    # least 2).
    #
    # The Cantor pairing function uniquely encodes pairs of natural numbers
    # into a single natural number. This implementation extends it to tuples.
    #
    # @param xs [Array<Integer>] Array of integers to encode
    # @return [Integer] Unique natural number representing the tuple
    def cantor_pairing(*xs)
      CantorPairingFunction.cantor_pairing(*xs)
    end

    # Returns the inverse of Cantor's tuple function for the value +c+. +n+ is
    # the length of the tuple (defaults to 2, a pair).
    #
    # Decodes a natural number back into its original tuple representation.
    #
    # @param c [Integer] The encoded natural number
    # @param n [Integer] Length of the original tuple (default: 2)
    # @return [Array<Integer>] Original tuple as array of integers
    def cantor_pairing_inv(c, n = 2)
      CantorPairingFunction.cantor_pairing_inv(c, n)
    end

    # Computes a Gödel number from +string+ in the +alphabet+ and returns it.
    #
    # Implements Gödel numbering to convert strings into unique natural numbers.
    #
    # @param string [String] The input string
    # @param alphabet [Array<String>, Range<String>] The alphabet to use for conversion
    # @return [Integer] Unique Gödel number representing the string
    def numberify_string(string, alphabet = 'a'..'z')
      NumberifyStringFunction.numberify_string(string, alphabet)
    end

    # Computes the string in the +alphabet+ from a Gödel number +number+ and
    # returns it. This is the inverse function of numberify_string.
    #
    # Converts a natural number back to its original string representation.
    #
    # @param number [Integer] The Gödel number to convert
    # @param alphabet [Array<String>, Range<String>] The alphabet to use for conversion
    # @return [String] Original string represented by the number
    def stringify_number(number, alphabet = 'a'..'z')
      NumberifyStringFunction.stringify_number(number, alphabet)
    end

    # Includes entropy calculations functionality
    include Entropy
  end
end
