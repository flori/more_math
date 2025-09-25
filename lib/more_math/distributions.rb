require 'more_math/functions'
require 'more_math/constants/functions_constants'

module MoreMath
  # This class is used to compute the Normal Distribution.
  #
  # The normal distribution is a continuous probability distribution that
  # describes real-valued random variables whose distributions are symmetric
  # around their mean.
  #
  # @example Creating a normal distribution
  #   # Standard normal (mean=0, std_dev=1)
  #   norm = MoreMath::NormalDistribution.new
  #
  #   # Custom parameters
  #   custom_norm = MoreMath::NormalDistribution.new(5.0, 2.0)  # mean=5, std_dev=2
  #
  # @example Calculating probabilities
  #   norm = MoreMath::NormalDistribution.new
  #   p = norm.probability(1.96)     # Cumulative probability at z=1.96
  #   x = norm.inverse_probability(0.975)  # Inverse: find z such that P(Z <= z) = 0.975
  class NormalDistribution
    include Functions
    include Constants::FunctionsConstants

    # Creates a NormalDistribution instance for the values +mu+ and +sigma+.
    #
    # @param mu [Numeric] The mean of the distribution (default: 0.0)
    # @param sigma [Numeric] The standard deviation of the distribution (default: 1.0)
    def initialize(mu = 0.0, sigma = 1.0)
      @mu, @sigma = mu.to_f, sigma.to_f
    end

    # Returns the mean of this normal distribution.
    #
    # @return [Float] The mean value
    attr_reader :mu

    # Returns the standard deviation of this normal distribution.
    #
    # @return [Float] The standard deviation value
    attr_reader :sigma

    # Returns the cumulative probability (p-value) of the NormalDistribution
    # for the value +x+.
    #
    # This calculates P(X <= x) where X ~ N(μ, σ²).
    #
    # @param x [Numeric] The value at which to calculate the cumulative probability
    # @return [Float] The cumulative probability P(X <= x)
    def probability(x)
      0.5 * (1 + erf((x - @mu) / (@sigma * ROOT2)))
    end

    # Returns the inverse cumulative probability value of the
    # NormalDistribution for the probability +p+.
    #
    # This finds the value x such that P(X <= x) = p where X ~ N(μ, σ²).
    #
    # @param p [Numeric] The probability (0 < p < 1)
    # @return [Float] The inverse cumulative probability (quantile)
    def inverse_probability(p)
      case
      when p <= 0
        -1 / 0.0  # Negative infinity
      when p >= 1
        1 / 0.0   # Positive infinity
      when (p - 0.5).abs <= Float::EPSILON
        @mu       # Median equals mean for normal distribution
      else
        begin
          NewtonBisection.new { |x| probability(x) - p }.solve(nil, 1_000_000)
        rescue
          0 / 0.0   # NaN on error
        end
      end
    end
  end

  # A predefined instance of the standard normal distribution (mean=0, std_dev=1).
  #
  # @return [NormalDistribution] Standard normal distribution instance
  STD_NORMAL_DISTRIBUTION = NormalDistribution.new

  # This class is used to compute the Chi-Square Distribution.
  #
  # The chi-square distribution is a continuous probability distribution
  # that arises in the analysis of variance and goodness-of-fit tests.
  #
  # @example Creating a chi-square distribution
  #   chi2 = MoreMath::ChiSquareDistribution.new(5)  # 5 degrees of freedom
  #
  # @example Calculating probabilities
  #   chi2 = MoreMath::ChiSquareDistribution.new(5)
  #   p = chi2.probability(10.645)  # Probability that X <= 10.645
  class ChiSquareDistribution
    include Functions

    # Creates a ChiSquareDistribution for +df+ degrees of freedom.
    #
    # @param df [Integer] The degrees of freedom
    def initialize(df)
      @df = df
      @df_half = @df / 2.0
    end

    # Returns the degrees of freedom of this distribution.
    #
    # @return [Integer] The degrees of freedom
    attr_reader :df

    # Returns the cumulative probability (p-value) of the ChiSquareDistribution
    # for the value +x+.
    #
    # This calculates P(X <= x) where X ~ χ²(df).
    #
    # @param x [Numeric] The value at which to calculate the cumulative probability
    # @return [Float] The cumulative probability P(X <= x)
    def probability(x)
      if x < 0
        0.0
      else
        gammaP_regularized(x / 2, @df_half)
      end
    end

    # Returns the inverse cumulative probability value of the
    # ChiSquareDistribution for the probability +p+.
    #
    # This finds the value x such that P(X <= x) = p where X ~ χ²(df).
    #
    # @param p [Numeric] The probability (0 < p < 1)
    # @return [Float] The inverse cumulative probability (quantile)
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
          0 / 0.0   # NaN on error
        end
      end
    end
  end

  # This class is used to compute the T-Distribution.
  #
  # The t-distribution (Student's t-distribution) is a probability distribution
  # that is used when estimating the mean of a normally distributed population
  # in situations where the sample size is small and the population standard
  # deviation is unknown.
  #
  # @example Creating a t-distribution
  #   t_dist = MoreMath::TDistribution.new(10)  # 10 degrees of freedom
  #
  # @example Calculating probabilities
  #   t_dist = MoreMath::TDistribution.new(10)
  #   p = t_dist.probability(2.228)  # Probability that X <= 2.228
  class TDistribution
    include Functions

    # Returns a TDistribution instance for the degrees of freedom +df+.
    #
    # @param df [Integer] The degrees of freedom
    def initialize(df)
      @df = df
    end

    # Degrees of freedom.
    #
    # @return [Integer] The degrees of freedom
    attr_reader :df

    # Returns the cumulative probability (p-value) of the TDistribution for the
    # t-value +x+.
    #
    # This calculates P(X <= x) where X ~ t(df).
    #
    # @param x [Numeric] The t-value at which to calculate the cumulative probability
    # @return [Float] The cumulative probability P(X <= x)
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
    #
    # This finds the value x such that P(X <= x) = p where X ~ t(df).
    #
    # @param p [Numeric] The probability (0 < p < 1)
    # @return [Float] The inverse cumulative probability (quantile)
    def inverse_probability(p)
      case
      when p <= 0
        -1 / 0.0  # Negative infinity
      when p >= 1
        1 / 0.0   # Positive infinity
      else
        begin
          bisect = NewtonBisection.new { |x| probability(x) - p }
          range = bisect.bracket(-10..10)
          bisect.solve(range, 1_000_000)
        rescue
          0 / 0.0   # NaN on error
        end
      end
    end
  end
end
