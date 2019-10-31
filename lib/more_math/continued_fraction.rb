module MoreMath
  # This class implements a continued fraction of the form:
  #
  #                            b_1
  # a_0 + -------------------------
  #                            b_2
  #      a_1 + --------------------
  #                            b_3
  #           a_2 + ---------------
  #                            b_4
  #                a_3 + ----------
  #                            b_5
  #                     a_4 + -----
  #                            ...
  #
  class ContinuedFraction
    SIMPLE_B = proc { 1 }

    # Creates a continued fraction instance. With the defaults for_a { 1 } and
    # for_b { 1 } it approximates the golden ration phi if evaluated.
    def initialize
      @a = proc { 1 }
      @b = SIMPLE_B
    end

    # Creates a ContinuedFraction instances and passes its arguments to a call
    # to for_a.
    def self.for_a(arg = nil, &block)
      new.for_a(arg, &block)
    end

    # Creates a ContinuedFraction instances and passes its arguments to a call
    # to for_b.
    def self.for_b(arg = nil, &block)
      new.for_b(arg, &block)
    end

    def for_arg(arg = nil, &block)
      if arg and !block
        arg.freeze
      elsif block and !arg
        block
      else
        raise ArgumentError, "exactly one argument or one block required"
      end
    end
    private :for_arg

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

    # This method either takes a block or an argument +arg+. The argument +arg+
    # has to respond to an integer index n >= 0 and return the value a_n. The
    # block has to return the value for a_n when +n+ is passed as the first
    # argument to the block. If a_n is dependent on an +x+ value (see the call
    # method) the +x+ will be the second argument of the block.
    def for_a(arg = nil, &block)
      @a = for_arg(arg, &block)
      self
    end

    # This method either takes a block or an argument +arg+. The argument +arg+
    # has to respond to an integer index n >= 1 and return the value b_n. The
    # block has to return the value for b_n when +n+ is passed as the first
    # argument to the block. If b_n is dependent on an +x+ value (see the call
    # method) the +x+ will be the second argument of the block.
    def for_b(arg = nil, &block)
      @b = for_arg(arg, &block)
      self
    end

    def simple?
      @b == SIMPLE_B
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    include Enumerable
    def each(&block)
      if simple?
        (0..Float::INFINITY).lazy.map { |i| @a[i] }.take_while { |x| x }.each(&block)
      end
    end

    def to_s(length: 10)
      if simple?
        convergents = take(length)
        "[#{convergents[0]}; #{convergents[1..-1] * ', '}#{",…" if convergents.size >= length}]"
      else
        "CF(a=#@a, b=#@b)"
      end
    end

    def value(v, n, x = nil)
      result = if x
        v[n, x]
      else
        v[n]
      end and result.to_f
    end
    private :value

    # Returns the value for a_n or a_n(x).
    def a(n, x = nil)
      value(@a, n, x)
    end

    # Returns the value for b_n or b_n(x).
    def b(n, x = nil)
      value(@b, n, x)
    end

    # Evaluates the continued fraction for the value +x+ (if any) with the
    # accuracy +epsilon+ and +max_iterations+ as the maximum number of
    # iterations using the Wallis-method with scaling.
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

    def reciprocal
      if @a[0] > 0
        dup.for_a { |i| i == 0 ? 0 : @a[i - 1] }
      else
        dup.for_a { |i| @a[i + 1] }
      end
    end

    alias [] call

    alias to_f call

    # Returns this continued fraction as a Proc object which takes the same
    # arguments like its call method does.
    def to_proc
      proc { |*a| call(*a) }
    end
  end
end
