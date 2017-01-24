require 'more_math/entropy'

module MoreMath
  module Functions
    module_function

    include Math
    extend Math

    # Returns the natural logarithm of Euler gamma function value for +x+ using
    # the Lanczos approximation.
    if Math.respond_to?(:lgamma)
      def log_gamma(x)
        lgamma(x).first
      end
    else
      def log_gamma(x)
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

    # Returns the natural logarithm of the beta function value for +(a, b)+.
    def log_beta(a, b)
      log_gamma(a) + log_gamma(b) - log_gamma(a + b)
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    # Return an approximation value of Euler's regularized beta function for
    # +x+, +a+, and +b+ with an error <= +epsilon+, but only iterate
    # +max_iterations+-times.
    def beta_regularized(x, a, b, epsilon = 1E-16, max_iterations = 1 << 16)
      x, a, b = x.to_f, a.to_f, b.to_f
      case
      when a.nan? || b.nan? || x.nan? || a <= 0 || b <= 0 || x < 0 || x > 1
        0 / 0.0
      when x > (a + 1) / (a + b + 2)
        1 - beta_regularized(1 - x, b, a, epsilon, max_iterations)
      else
        fraction = ContinuedFraction.for_b do |n, x|
          if n % 2 == 0
            m = n / 2.0
            (m * (b - m) * x) / ((a + (2 * m) - 1) * (a + (2 * m)))
          else
            m = (n - 1) / 2.0
            -((a + m) * (a + b + m) * x) / ((a + 2 * m) * (a + 2 * m + 1))
          end
        end
        exp(a * log(x) + b * log(1.0 - x) - log(a) - log_beta(a, b)) /
          fraction[x, epsilon, max_iterations]
      end
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    # Return an approximation of the regularized gammaP function for +x+ and
    # +a+ with an error of <= +epsilon+, but only iterate
    # +max_iterations+-times.
    def gammaP_regularized(x, a, epsilon = 1E-16, max_iterations = 1 << 16)
      x, a = x.to_f, a.to_f
      case
      when a.nan? || x.nan? || a <= 0 || x < 0
        0 / 0.0
      when x == 0
        0.0
      when 1 <= a && a < x
        1 - gammaQ_regularized(x, a, epsilon, max_iterations)
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
    def gammaQ_regularized(x, a, epsilon = 1E-16, max_iterations = 1 << 16)
      x, a = x.to_f, a.to_f
      case
      when a.nan? || x.nan? || a <= 0 || x < 0
        0 / 0.0
      when x == 0
        1.0
      when a > x || a < 1
        1 - gammaP_regularized(x, a, epsilon, max_iterations)
      else
        fraction = ContinuedFraction.for_a do |n, x|
          (2 * n + 1) - a + x
        end.for_b do |n, x|
          n * (a - n)
        end
        exp(-x + a * log(x) - log_gamma(a)) *
          fraction[x, epsilon, max_iterations] ** -1
      end
    rescue Errno::ERANGE, Errno::EDOM
      0 / 0.0
    end

    unless Math.respond_to?(:erf)
      # Returns an approximate value for the error function's value for +x+.
      def erf(x)
        erf_a = MoreMath::Constants::FunctionsConstants::ERF_A
        r = sqrt(1 - exp(-x ** 2 * (4 / Math::PI + erf_a * x ** 2) / (1 + erf_a * x ** 2)))
        x < 0 ? -r : r
      end
    else
      def erf(x)
        Math.erf(x)
      end
    end

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

    # Returns the base +b+ logarithm of the number +x+. +b+  defaults to base
    # 2, binary logarithm.
    def logb(x, b = 2)
      Math.log(x) / Math.log(b)
    end

    # Returns Cantor's tuple function for the tuple +*xs+ (the size must be at
    # least 2).
    def cantor_pairing(*xs)
      CantorPairingFunction.cantor_pairing(*xs)
    end

    # Returns the inverse of Cantor's tuple function for the value +c+. +n+ is
    # the length of the tuple (defaults to 2, a pair).
    def cantor_pairing_inv(c, n = 2)
      CantorPairingFunction.cantor_pairing_inv(c, n)
    end

    # Computes a Gödel number from +string+ in the +alphabet+ and returns it.
    def numberify_string(string, alphabet = 'a'..'z')
      NumberifyStringFunction.numberify_string(string, alphabet)
    end

    # Computes the string in the +alphabet+ from a Gödel number +number+ and
    # returns it. This is the inverse function of numberify_string.
    def stringify_number(number, alphabet = 'a'..'z')
      NumberifyStringFunction.stringify_number(number, alphabet)
    end

    include Entropy
  end
end
