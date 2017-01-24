require 'more_math/functions'
require 'more_math/constants/functions_constants'

module MoreMath
  # This class is used to compute the Normal Distribution.
  class NormalDistribution
    include Functions
    include Constants::FunctionsConstants

    # Creates a NormalDistribution instance for the values +mu+ and +sigma+.
    def initialize(mu = 0.0, sigma = 1.0)
      @mu, @sigma = mu.to_f, sigma.to_f
    end

    attr_reader :mu

    attr_reader :sigma

    # Returns the cumulative probability (p-value) of the NormalDistribution
    # for the value +x+.
    def probability(x)
      0.5 * (1 + erf((x - @mu) / (@sigma * ROOT2)))
    end

    # Returns the inverse cumulative probability value of the
    # NormalDistribution for the probability +p+.
    def inverse_probability(p)
      case
      when p <= 0
        -1 / 0.0
      when p >= 1
        1 / 0.0
      when (p - 0.5).abs <= Float::EPSILON
        @mu
      else
        begin
          NewtonBisection.new { |x| probability(x) - p }.solve(nil, 1_000_000)
        rescue
          0 / 0.0
        end
      end
    end
  end

  STD_NORMAL_DISTRIBUTION = NormalDistribution.new

  # This class is used to compute the Chi-Square Distribution.
  class ChiSquareDistribution
    include Functions

    # Creates a ChiSquareDistribution for +df+ degrees of freedom.
    def initialize(df)
      @df = df
      @df_half = @df / 2.0
    end

    attr_reader :df

    # Returns the cumulative probability (p-value) of the ChiSquareDistribution
    # for the value +x+.
    def probability(x)
      if x < 0
        0.0
      else
        gammaP_regularized(x / 2, @df_half)
      end
    end

    # Returns the inverse cumulative probability value of the
    # NormalDistribution for the probability +p+.
    def inverse_probability(p)
      case
      when p <= 0, p >= 1
        0.0
      else
        begin
          bisect = NewtonBisection.new { |x| probability(x) - p }
          range = bisect.bracket 0.5..10
          bisect.solve(range, 1_000_000)
        rescue
          0 / 0.0
        end
      end
    end
  end

  # This class is used to compute the T-Distribution.
  class TDistribution
    include Functions

    # Returns a TDistribution instance for the degrees of freedom +df+.
    def initialize(df)
      @df = df
    end

    # Degrees of freedom.
    attr_reader :df

    # Returns the cumulative probability (p-value) of the TDistribution for the
    # t-value +x+.
    def probability(x)
      if x == 0
        0.5
      else
        t = beta_regularized(@df / (@df + x ** 2.0), 0.5 * @df, 0.5)
        if x < 0.0
          0.5 * t
        else
          1 - 0.5 * t
        end
      end
    end

    # Returns the inverse cumulative probability (t-value) of the TDistribution
    # for the probability +p+.
    def inverse_probability(p)
      case
      when p <= 0
        -1 / 0.0
      when p >= 1
        1 / 0.0
      else
        begin
          bisect = NewtonBisection.new { |x| probability(x) - p }
          range = bisect.bracket(-10..10)
          bisect.solve(range, 1_000_000)
        rescue
          0 / 0.0
        end
      end
    end
  end
end
