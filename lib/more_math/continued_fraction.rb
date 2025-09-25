module MoreMath
  # A continued fraction implementation that supports both simple and
  # generalized continued fractions.
  #
  # Continued fractions are represented in the form:
  #   a₀ + b₁ / (a₁ + b₂ / (a₂ + b₃ / (a₃ + ...)))
  #
  # For simple continued fractions, all `b` coefficients default to 1,
  # and only `a` coefficients vary.
  #
  # @example Simple continued fraction for φ (golden ratio)
  #   phi = ContinuedFraction.new
  #   phi.() # => 1.618033988749895
  #
  # @example Generalized continued fraction for √2
  #   sqrt_2 = ContinuedFraction.for_a { |n| n == 0 ? 1 : 2 }
  #   sqrt_2.()  # => 1.4142135623730951
  #
  # @example Generalized continued fraction for π (finite)
  #   pi = ContinuedFraction.for_a [3, 7, 15, 1, 292, 1, 1, 1, 2]
  #   pi.() # => 3.141592653581078
  #
  # @example Continued fraction with variable coefficients
  #   atan = ContinuedFraction.for_a do |n, x|
  #     n == 0 ? 0 : 2 * n - 1
  #   end.for_b do |n, x|
  #     n <= 1 ? x : ((n - 1) * x) ** 2
  #   end
  #   atan.(0.5)  # => 0.4636476090008061
  class ContinuedFraction
    # Default b coefficient generator (returns 1 for all indices)
    SIMPLE_B = proc { 1 }

    # Creates a new continued fraction with default coefficients.
    # The defaults for `a` and `b` are both set to 1, which approximates
    # the golden ratio when evaluated.
    #
    # @example Create a new instance
    #   cf = ContinuedFraction.new
    def initialize
      @a = proc { 1 }
      @b = SIMPLE_B
    end

    # Creates a continued fraction instance and sets its `a` coefficients.
    # This is a class method for convenience when building continued fractions.
    #
    # @example Using an array of values
    #   cf = ContinuedFraction.for_a([1, 2, 3])
    #
    # @example Using a block
    #   cf = ContinuedFraction.for_a { |n| n + 1 }
    #
    # @param arg [Array, nil] An array of coefficients or nil to use a block.
    # @yield [index] A block that returns the coefficient for index `n`.
    # @yieldparam index [Integer] The index of the coefficient to retrieve.
    # @return [ContinuedFraction] A new continued fraction with specified `a` coefficients.
    def self.for_a(arg = nil, &block)
      new.for_a(arg, &block)
    end

    # Creates a continued fraction instance and sets its `b` coefficients.
    # This is a class method for convenience when building continued fractions.
    #
    # @example Using an array of values
    #   cf = ContinuedFraction.for_b([1, 2, 3])
    #
    # @example Using a block
    #   cf = ContinuedFraction.for_b { |n| n + 1 }
    #
    # @param arg [Array, nil] An array of coefficients or nil to use a block.
    # @yield [index] A block that returns the coefficient for index `n`.
    # @yieldparam index [Integer] The index of the coefficient to retrieve.
    # @return [ContinuedFraction] A new continued fraction with specified `b` coefficients.
    def self.for_b(arg = nil, &block)
      new.for_b(arg, &block)
    end

    # Helper method to validate and process arguments for `for_a` and `for_b`.
    #
    # @api private
    def for_arg(arg = nil, &block)
      if arg && !block
        arg.freeze
      elsif block && !arg
        block
      else
        raise ArgumentError, "exactly one argument or one block required"
      end
    end
    private :for_arg

    # Creates a continued fraction from a Rational number.
    #
    # @example Create a continued fraction for π
    #   pi_cf = ContinuedFraction.from(Math::PI)
    #
    # @param number [Numeric] The number to convert into a continued fraction.
    # @return [ContinuedFraction] A continued fraction representation of the number.
    def self.from(number)
      number = number.to_r
      n, d = number.numerator, number.denominator
      as = []
      while d > 0
        n, (a, d) = d, n.divmod(d)
        as << a
      end
      for_a(as)
    end

    # Sets the `a` coefficients for this continued fraction.
    #
    # @example Using an array of values
    #   cf = ContinuedFraction.new.for_a([1, 2, 3])
    #
    # @example Using a block
    #   cf = ContinuedFraction.new.for_a { |n| n + 1 }
    #
    # @param arg [Array, nil] An array of coefficients or nil to use a block.
    # @yield [index] A block that returns the coefficient for index `n`.
    # @yieldparam index [Integer] The index of the coefficient to retrieve.
    # @return [ContinuedFraction] Returns self for chaining.
    def for_a(arg = nil, &block)
      @a = for_arg(arg, &block)
      self
    end

    # Sets the `b` coefficients for this continued fraction.
    #
    # @example Using an array of values
    #   cf = ContinuedFraction.new.for_b([1, 2, 3])
    #
    # @example Using a block
    #   cf = ContinuedFraction.new.for_b { |n| n + 1 }
    #
    # @param arg [Array, nil] An array of coefficients or nil to use a block.
    # @yield [index] A block that returns the coefficient for index `n`.
    # @yieldparam index [Integer] The index of the coefficient to retrieve.
    # @return [ContinuedFraction] Returns self for chaining.
    def for_b(arg = nil, &block)
      @b = for_arg(arg, &block)
      self
    end

    # Checks if this is a simple continued fraction (all `b` coefficients are 1).
    #
    # @return [Boolean] True if all `b` coefficients are 1.
    def simple?
      @b == SIMPLE_B
    end

    # Returns a string representation of the continued fraction.
    #
    # @param length [Integer] The number of terms to display for simple fractions.
    # @return [String] A formatted string representation.
    def to_s(length: 10)
      if simple?
        convergents = take(length)
        "[#{convergents[0]}; #{convergents[1..-1] * ', '}#{",…" if convergents.size >= length}]"
      else
        "CF(a=#@a, b=#@b)"
      end
    end

    # Returns a string representation of the continued fraction.
    #
    # @return [String] A detailed string representation for debugging.
    def inspect
      "#<#{self.class} #{to_s}>"
    end

    # Includes Enumerable module to allow iteration over convergents.
    include Enumerable

    # Iterates over convergents of this continued fraction (only for simple fractions).
    #
    # @yield [convergent] Yields each convergent value.
    # @yieldparam convergent [Float] The next convergent in the sequence.
    def each(&block)
      if simple?
        (0..Float::INFINITY).lazy.map { |i| @a[i] }.take_while { |x| x }.each(&block)
      end
    end

    # Evaluates the continued fraction for a given value `x`.
    #
    # For generalized continued fractions, the coefficients may depend on an external parameter `x`.
    # The Wallis method with scaling is used for convergence.
    #
    # @example Evaluate the golden ratio
    #   phi = ContinuedFraction.new
    #   phi.()  # => 1.618033988749895
    #
    # @example Evaluate atan(0.5)
    #   atan = ContinuedFraction.for_a { |n, x| n == 0 ? 0 : 2 * n - 1 }
    #                        .for_b { |n, x| n <= 1 ? x : ((n - 1) * x) ** 2 }
    #   atan.(0.5)  # => 0.4636476090008061
    #
    # @param x [Numeric, nil] Optional external parameter for variable coefficients.
    # @param epsilon [Float] Convergence tolerance (default: 1e-16).
    # @param max_iterations [Integer] Maximum number of iterations (default: 2^31).
    # @return [Float] The evaluated result of the continued fraction.
    def call(x = nil, epsilon: 1E-16, max_iterations: 1 << 31)
      c_0, c_1 = 1.0, a(0, x)
      c_1 == nil and return 0 / 0.0
      d_0, d_1 = 0.0, 1.0
      result = c_1 / d_1
      n = 0
      error = 1 / 0.0
      $DEBUG and warn "n=%u, a=%f, b=nil, c=%f, d=%f result=%f, error=nil" %
        [ n, c_1, c_1, d_1, result ]
      while n < max_iterations and error > epsilon
        n += 1
        a_n, b_n = a(n, x), b(n, x)
        a_n and b_n or break
        c_2 = a_n * c_1 + b_n * c_0
        d_2 = a_n * d_1 + b_n * d_0
        if c_2.infinite? or d_2.infinite?
          if a_n != 0
            c_2 = c_1 + (b_n / a_n * c_0)
            d_2 = d_1 + (b_n / a_n * d_0)
          elsif b_n != 0
            c_2 = (a_n / b_n * c_1) + c_0
            d_2 = (a_n / b_n * d_1) + d_0
          else
            raise Errno::ERANGE
          end
        end
        r = c_2 / d_2
        error = (r / result - 1).abs

        result = r

        $DEBUG and warn "n=%u, a=%f, b=%f, c=%f, d=%f, result=%f, error=%.16f" %
          [ n, a_n, b_n, c_1, d_1, result, error ]

        c_0, c_1 = c_1, c_2
        d_0, d_1 = d_1, d_2
      end
      n >= max_iterations and raise Errno::ERANGE
      result
    end

    # Returns the reciprocal of this continued fraction.
    #
    # @return [ContinuedFraction] A new continued fraction representing the reciprocal.
    def reciprocal
      if @a[0] > 0
        dup.for_a { |i| i == 0 ? 0 : @a[i - 1] }
      else
        dup.for_a { |i| @a[i + 1] }
      end
    end

    # Alias for the `call` method.
    alias [] call

    # Alias for the `call` method.
    alias to_f call

    # Converts this continued fraction into a Proc that can be called directly.
    #
    # @return [Proc] A proc that accepts the same arguments as `call`.
    def to_proc
      proc { |*a| call(*a) }
    end

    private

    # Helper method for retrieving coefficient values, supporting both indexed access and block evaluation.
    #
    # @api private
    def value(v, n, x = nil)
      result = if x
        v[n, x]
      else
        v[n]
      end and result.to_f
    end

    # Returns the value for a_n or a_n(x).
    #
    # @api private
    def a(n, x = nil)
      value(@a, n, x)
    end

    # Returns the value for b_n or b_n(x).
    #
    # @api private
    def b(n, x = nil)
      value(@b, n, x)
    end
  end
end
