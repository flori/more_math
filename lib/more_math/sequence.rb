require 'more_math/sequence/moving_average'
require 'more_math/sequence/refinement'

module MoreMath
  # A sequence class for statistical analysis and mathematical operations.
  #
  # This class provides comprehensive statistical functionality including:
  # - Basic sequence operations (iteration, size, etc.)
  # - Statistical measures (mean, variance, standard deviation)
  # - Advanced statistical methods (percentiles, confidence intervals)
  # - Time series analysis (moving averages, autocorrelation)
  # - Hypothesis testing (t-tests, confidence intervals)
  # - Data visualization tools (histograms)
  #
  # @example Basic usage
  #   sequence = Sequence.new([1, 2, 3, 4, 5])
  #   puts sequence.mean        # => 3.0
  #   puts sequence.variance    # => 2.0
  #   sequence.simple_moving_average(3) # => [2.0, 3.0, 4.0]
  #
  # @example Statistical analysis
  #   data = Sequence.new([10, 15, 20, 25, 30])
  #   puts data.percentile(90)      # => 28.0
  #   puts data.confidence_interval(0.05) # => 17.0..23.0
  class Sequence
    include MoreMath::Sequence::MovingAverage

    # Initializes a new Sequence instance with the given elements.
    #
    # @param elements [Array] The array of elements to store in this sequence
    def initialize(elements)
      @elements = elements.dup.freeze
    end

    # Returns the array of elements.
    #
    # @return [Array] The frozen array of elements in this sequence
    attr_reader :elements

    # Calls the block for every element of this Sequence.
    #
    # @yield [element] Yields each element to the block
    # @yieldparam element [Object] Each element in the sequence
    # @return [self] Returns self to allow method chaining
    def each(&block)
      @elements.each(&block)
    end
    include Enumerable

    # Returns true if this sequence is empty, otherwise false.
    #
    # @return [Boolean] true if sequence has no elements, false otherwise
    def empty?
      @elements.empty?
    end

    # Returns the number of elements in this sequence.
    #
    # @return [Integer] The count of elements in the sequence
    def size
      @elements.size
    end

    # Reset all memoized values of this sequence.
    #
    # @return [self] Returns self after clearing memoization cache
    def reset
      self.class.mize_cache_clear
      self
    end

    # Converts the sequence to an array.
    #
    # @return [Array] A duplicate of the internal elements array
    def to_ary
      @elements.dup
    end

    alias to_a to_ary

    # Pushes an element onto this Sequence and returns a new Sequence instance.
    #
    # @param element [Object] The element to add to the sequence
    # @return [Sequence] A new Sequence instance with the element added
    def push(element)
      Sequence.new(@elements.dup.push(element))
    end

    alias << push

    # Returns the variance of the elements.
    #
    # Variance measures how far each number in the set is from the mean.
    #
    # @return [Float] The population variance of the elements
    # @note Uses the formula: Σ(xi - μ)² / n
    memoize method:
    def variance
      sum_of_squares / size
    end

    # Returns the sample variance of the elements.
    #
    # Sample variance is used when the data represents a sample rather than a population.
    #
    # @return [Float] The sample variance of the elements
    # @note Uses the formula: Σ(xi - μ)² / (n-1)
    memoize method:
    def sample_variance
      size > 1 ? sum_of_squares / (size - 1.0) : 0.0
    end

    # Returns the sum of squares of the elements.
    #
    # Sum of squares is used in variance and standard deviation calculations.
    #
    # @return [Float] The sum of squared deviations from the mean
    memoize method:
    def sum_of_squares
      @elements.inject(0.0) { |s, t| s + (t - arithmetic_mean) ** 2 }
    end

    # Returns the standard deviation of the elements.
    #
    # Standard deviation measures the amount of variation or dispersion in a set of values.
    #
    # @return [Float] The population standard deviation
    memoize method:
    def standard_deviation
      Math.sqrt(variance)
    end

    # Returns the Z-score sequence derived from the current sequence.
    #
    # Z-scores standardize data by transforming it to have a mean of 0 and standard deviation of 1.
    #
    # @return [Sequence] A new Sequence with z-score values
    memoize method:
    def z_score
      self.class.new(elements.map { |t| t.to_f - mean / standard_deviation })
    end

    # Returns the standard deviation as a percentage of the arithmetic mean.
    #
    # @return [Float] Standard deviation expressed as a percentage of the mean
    memoize method:
    def standard_deviation_percentage
      100.0 * standard_deviation / arithmetic_mean
    end

    # Returns the sample standard deviation of the elements.
    #
    # @return [Float] The sample standard deviation
    memoize method:
    def sample_standard_deviation
      Math.sqrt(sample_variance)
    end

    # Returns the sample standard deviation as a percentage of the arithmetic mean.
    #
    # @return [Float] Sample standard deviation expressed as a percentage of the mean
    memoize method:
    def sample_standard_deviation_percentage
      100.0 * sample_standard_deviation / arithmetic_mean
    end

    # Returns the sum of all elements.
    #
    # @return [Float] The sum of all elements in the sequence
    memoize method:
    def sum
      @elements.inject(0.0) { |s, t| s + t }
    end

    # Returns the arithmetic mean of the elements.
    #
    # @return [Float] The arithmetic mean (average) of the elements
    memoize method:
    def arithmetic_mean
      sum / size
    end

    alias mean arithmetic_mean

    # Returns the harmonic mean of the elements.
    #
    # The harmonic mean is useful for rates and ratios. Returns NaN if any element is <= 0.
    #
    # @return [Float] The harmonic mean, or NaN if invalid input
    memoize method:
    def harmonic_mean
      sum = @elements.inject(0.0) { |s, t|
        if t > 0
          s + 1.0 / t
        else
          break nil
        end
      }
      sum ? size / sum : 0 / 0.0
    end

    # Returns the geometric mean of the elements.
    #
    # The geometric mean is useful for sets of positive numbers that are to be multiplied together.
    # Returns NaN if any element is negative, 0 if any element is zero.
    #
    # @return [Float] The geometric mean, or NaN if invalid input
    memoize method:
    def geometric_mean
      sum = @elements.inject(0.0) { |s, t|
        case
        when t > 0
          s + Math.log(t)
        when t == 0
          break :null
        else
          break nil
        end
      }
      case sum
      when :null
        0.0
      when Float
        Math.exp(sum / size)
      else
        0 / 0.0
      end
    end

    # Returns the minimum of the elements.
    #
    # @return [Object] The minimum element in the sequence
    memoize method:
    def min
      @elements.min
    end

    # Returns the maximum of the elements.
    #
    # @return [Object] The maximum element in the sequence
    memoize method:
    def max
      @elements.max
    end

    # Returns a sorted array of the elements.
    #
    # @return [Array] A new array containing elements sorted in ascending order
    memoize method:
    def sorted
      @elements.sort
    end

    # Returns the p-percentile of the elements.
    #
    # Uses weighted average at x_(n + 1)p for interpolation between percentiles.
    #
    # @param p [Integer, Float] The percentile to calculate (0-99)
    # @return [Float] The p-th percentile value
    # @raise [ArgumentError] If p is not in the range (0...100)
    def percentile(p = 50)
      (0...100).include?(p) or
        raise ArgumentError, "p = #{p}, but has to be in (0...100)"
      p /= 100.0
      sorted_elements = sorted
      r = p * (sorted_elements.size + 1)
      r_i = r.to_i
      r_f = r - r_i
      if r_i >= 1
        result = sorted_elements[r_i - 1]
        if r_i < sorted_elements.size
          result += r_f * (sorted_elements[r_i] - sorted_elements[r_i - 1])
        end
      else
        result = sorted_elements[0]
      end
      result
    end

    alias median percentile

    # Computes the degrees of freedom for Welch's t-test.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Float] The degrees of freedom for Welch's t-test
    def compute_welch_df(other)
      (sample_variance / size + other.sample_variance / other.size) ** 2 / (
        (sample_variance ** 2 / (size ** 2 * (size - 1))) +
        (other.sample_variance ** 2 / (other.size ** 2 * (other.size - 1))))
    end

    # Returns the t value of the Welch's t-test between this sequence and another.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Float] The t-statistic value
    def t_welch(other)
      signal = arithmetic_mean - other.arithmetic_mean
      noise = Math.sqrt(sample_variance / size +
        other.sample_variance / other.size)
      signal / noise
    rescue Errno::EDOM
      0.0
    end

    # Returns an estimation of the common standard deviation of this and another sequence.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Float] The pooled standard deviation estimate
    def common_standard_deviation(other)
      Math.sqrt(common_variance(other))
    end

    # Returns an estimation of the common variance of this and another sequence.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Float] The pooled variance estimate
    def common_variance(other)
      (size - 1) * sample_variance + (other.size - 1) *
        other.sample_variance / (size + other.size - 2)
    end

    # Computes the degrees of freedom for Student's t-test.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Integer] The degrees of freedom for Student's t-test
    def compute_student_df(other)
      size + other.size - 2
    end

    # Returns the t value of the Student's t-test between this sequence and another.
    #
    # @param other [Sequence] The other sequence to compare against
    # @return [Float] The t-statistic value
    def t_student(other)
      signal = arithmetic_mean - other.arithmetic_mean
      noise = common_standard_deviation(other) *
        Math.sqrt(size ** -1 + size ** -1)
      signal / noise
    rescue Errno::EDOM
      0.0
    end

    # Computes the suggested sample size for detecting a mean difference.
    #
    # @param other [Sequence] The other sequence to compare against
    # @param alpha [Float] The significance level (default: 0.05)
    # @param beta [Float] The Type II error probability (default: 0.05)
    # @return [Float] The suggested sample size
    def suggested_sample_size(other, alpha = 0.05, beta = 0.05)
      alpha, beta = alpha.abs, beta.abs
      signal = arithmetic_mean - other.arithmetic_mean
      df = size + other.size - 2
      pooled_variance_estimate = (sum_of_squares + other.sum_of_squares) / df
      td = TDistribution.new df
      (((td.inverse_probability(alpha) + td.inverse_probability(beta)) *
        Math.sqrt(pooled_variance_estimate)) / signal) ** 2
    end

    # Determines if this sequence covers another sequence at the given alpha level.
    #
    # @param other [Sequence] The other sequence to compare against
    # @param alpha [Float] The significance level (default: 0.05)
    # @return [Boolean] true if sequences are statistically equivalent
    def cover?(other, alpha = 0.05)
      t = t_welch(other)
      td = TDistribution.new(compute_welch_df(other))
      t.abs < td.inverse_probability(1 - alpha.abs / 2.0)
    end

    # Returns the confidence interval for the arithmetic mean.
    #
    # @param alpha [Float] The significance level (default: 0.05)
    # @return [Range] The confidence interval as a range object
    def confidence_interval(alpha = 0.05)
      td = TDistribution.new(size - 1)
      t = td.inverse_probability(alpha / 2).abs
      delta = t * sample_standard_deviation / Math.sqrt(size)
      (arithmetic_mean - delta)..(arithmetic_mean + delta)
    end

    # Returns the array of autovariances.
    #
    # @return [Array<Float>] Array of autovariance values
    def autovariance
      Array.new(size - 1) do |k|
        s = 0.0
        0.upto(size - k - 1) do |i|
          s += (@elements[i] - arithmetic_mean) * (@elements[i + k] - arithmetic_mean)
        end
        s / size
      end
    end

    # Returns the array of autocorrelation values.
    #
    # @return [Array<Float>] Array of autocorrelation values (normalized by first variance)
    def autocorrelation
      c = autovariance
      Array.new(c.size) { |k| c[k] / c[0] }
    end

    # Returns the d-value for the Durbin-Watson statistic.
    #
    # @return [Float] The Durbin-Watson statistic value (close to 2 indicates no autocorrelation)
    def durbin_watson_statistic
      e = linear_regression.residuals
      e.size <= 1 and return 2.0
      (1...e.size).inject(0.0) { |s, i| s + (e[i] - e[i - 1]) ** 2 } /
        e.inject(0.0) { |s, x| s + x ** 2 }
    end

    # Returns the q value of the Ljung-Box statistic.
    #
    # @param lags [Integer] The number of lags to consider (default: 20)
    # @return [Float, nil] The Ljung-Box statistic value or nil if insufficient data
    def ljung_box_statistic(lags = 20)
      r = autocorrelation
      lags >= r.size and return
      n = size
      n * (n + 2) * (1..lags).inject(0.0) { |s, i| s + r[i] ** 2 / (n - i) }
    end

    # Detects autocorrelation using the Ljung-Box statistic.
    #
    # @param lags [Integer] The number of lags to consider (default: 20)
    # @param alpha_level [Float] The significance level (default: 0.05)
    # @return [Hash, nil] Results hash or nil if insufficient data
    def detect_autocorrelation(lags = 20, alpha_level = 0.05)
      if q = ljung_box_statistic(lags)
        p = ChiSquareDistribution.new(lags).probability(q)
        return {
          :lags         => lags,
          :alpha_level  => alpha_level,
          :q            => q,
          :p            => p,
          :detected     => p >= 1 - alpha_level,
        }
      end
    end

    # Returns the interquartile range for this sequence.
    #
    # @return [Float] The difference between 75th and 25th percentiles
    def interquartile_range
      quartile1 = percentile(25)
      quartile3 = percentile(75)
      quartile3 - quartile1
    end

    # Detects outliers using the boxplot algorithm.
    #
    # @param factor [Float] The multiplier for IQR to define outlier boundaries (default: 3.0)
    # @param epsilon [Float] Small value for numerical stability (default: 1E-5)
    # @return [Hash, nil] Outlier statistics or nil if no outliers or insufficient data
    def detect_outliers(factor = 3.0, epsilon = 1E-5)
      half_factor = factor / 2.0
      quartile1 = percentile(25)
      quartile3 = percentile(75)
      iqr = quartile3 - quartile1
      iqr < epsilon and return
      result = @elements.inject(Hash.new(0)) do |h, t|
        extreme =
          case t
          when -Infinity..(quartile1 - factor * iqr)
            :very_low
          when (quartile1 - factor * iqr)..(quartile1 - half_factor * iqr)
            :low
          when (quartile1 + half_factor * iqr)..(quartile3 + factor * iqr)
            :high
          when (quartile3 + factor * iqr)..Infinity
            :very_high
          end and h[extreme] += 1
        h
      end
      unless result.empty?
        result[:median] = median
        result[:iqr] = iqr
        result[:factor] = factor
        result
      end
    end

    # Returns the LinearRegression object for this sequence.
    #
    # @return [LinearRegression] The linear regression model for this data
    memoize method:
    def linear_regression
      LinearRegression.new @elements
    end

    # Creates a Histogram instance from this sequence.
    #
    # @param bins [Integer] The number of bins for the histogram
    # @return [Histogram] A new Histogram instance
    def histogram(bins)
      Histogram.new(self, bins)
    end
  end
end
