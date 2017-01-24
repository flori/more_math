require 'more_math/sequence/moving_average'
require 'more_math/sequence/refinement'

module MoreMath
  # This class is used to contain elements and compute various statistical
  # values for them.
  class Sequence
    include MoreMath::Sequence::MovingAverage

    def initialize(elements)
      @elements = elements.dup.freeze
    end

    # Returns the array of elements.
    attr_reader :elements

    # Calls the +block+ for every element of this Sequence.
    def each(&block)
      @elements.each(&block)
    end
    include Enumerable

    # Returns true if this sequence is empty, otherwise false.
    def empty?
      @elements.empty?
    end

    # Returns the number of elements, on which the analysis is based.
    def size
      @elements.size
    end

    # Reset all memoized values of this sequence.
    def reset
      self.class.mize_cache_clear
      self
    end

    def to_ary
      @elements.dup
    end

    alias to_a to_ary

    # Push +element+ on this Sequence and return a new Sequence instance with
    # +element+ as its last element.
    def push(element)
      Sequence.new(@elements.dup.push(element))
    end
    alias << push

    # Returns the variance of the elements.
    memoize method:
    def variance
      sum_of_squares / size
    end

    # Returns the sample_variance of the elements.
    memoize method:
    def sample_variance
      size > 1 ? sum_of_squares / (size - 1.0) : 0.0
    end

    # Returns the sum of squares (the sum of the squared deviations) of the
    # elements.
    memoize method:
    def sum_of_squares
      @elements.inject(0.0) { |s, t| s + (t - arithmetic_mean) ** 2 }
    end

    # Returns the standard deviation of the elements.
    memoize method:
    def standard_deviation
      Math.sqrt(variance)
    end

    # Returns the standard deviation of the elements in percentage of the
    # arithmetic mean.
    memoize method:
    def standard_deviation_percentage
      100.0 * standard_deviation / arithmetic_mean
    end

    # Returns the sample standard deviation of the elements.
    memoize method:
    def sample_standard_deviation
      Math.sqrt(sample_variance)
    end

    # Returns the sample standard deviation of the elements in percentage
    # of the arithmetic mean.
    memoize method:
    def sample_standard_deviation_percentage
      100.0 * sample_standard_deviation / arithmetic_mean
    end

    # Returns the sum of all elements.
    memoize method:
    def sum
      @elements.inject(0.0) { |s, t| s + t }
    end

    # Returns the arithmetic mean of the elements.
    memoize method:
    def arithmetic_mean
      sum / size
    end

    alias mean arithmetic_mean

    # Returns the harmonic mean of the elements. If any of the elements
    # is less than or equal to 0.0, this method returns NaN.
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

    # Returns the geometric mean of the elements. If any of the
    # elements is less than 0.0, this method returns NaN.
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
    memoize method:
    def min
      @elements.min
    end

    # Returns the maximum of the elements.
    memoize method:
    def max
      @elements.max
    end

    # Return a sorted array of the elements.
    memoize method:
    def sorted
      @elements.sort
    end

    # Returns the +p+-percentile of the elements.
    # There are many methods to compute the percentile, this method uses the
    # the weighted average at x_(n + 1)p, which allows p to be in 0...100
    # (excluding the 100).
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

    # Use an approximation of the Welch-Satterthwaite equation to compute the
    # degrees of freedom for Welch's t-test.
    def compute_welch_df(other)
      (sample_variance / size + other.sample_variance / other.size) ** 2 / (
        (sample_variance ** 2 / (size ** 2 * (size - 1))) +
        (other.sample_variance ** 2 / (other.size ** 2 * (other.size - 1))))
    end

    # Returns the t value of the Welch's t-test between this Sequence
    # instance and the +other+.
    def t_welch(other)
      signal = arithmetic_mean - other.arithmetic_mean
      noise = Math.sqrt(sample_variance / size +
        other.sample_variance / other.size)
      signal / noise
    rescue Errno::EDOM
      0.0
    end

    # Returns an estimation of the common standard deviation of the
    # elements of this and +other+.
    def common_standard_deviation(other)
      Math.sqrt(common_variance(other))
    end

    # Returns an estimation of the common variance of the elements of this
    # and +other+.
    def common_variance(other)
      (size - 1) * sample_variance + (other.size - 1) *
        other.sample_variance / (size + other.size - 2)
    end

    # Compute the # degrees of freedom for Student's t-test.
    def compute_student_df(other)
      size + other.size - 2
    end

    # Returns the t value of the Student's t-test between this Sequence
    # instance and the +other+.
    def t_student(other)
      signal = arithmetic_mean - other.arithmetic_mean
      noise = common_standard_deviation(other) *
        Math.sqrt(size ** -1 + size ** -1)
      signal / noise
    rescue Errno::EDOM
      0.0
    end

    # Compute a sample size, that will more likely yield a mean difference
    # between this instance's elements and those of +other+. Use +alpha+
    # and +beta+ as levels for the first- and second-order errors.
    def suggested_sample_size(other, alpha = 0.05, beta = 0.05)
      alpha, beta = alpha.abs, beta.abs
      signal = arithmetic_mean - other.arithmetic_mean
      df = size + other.size - 2
      pooled_variance_estimate = (sum_of_squares + other.sum_of_squares) / df
      td = TDistribution.new df
      (((td.inverse_probability(alpha) + td.inverse_probability(beta)) *
        Math.sqrt(pooled_variance_estimate)) / signal) ** 2
    end

    # Return true, if the Sequence instance covers the +other+, that is their
    # arithmetic mean value is most likely to be equal for the +alpha+ error
    # level.
    def cover?(other, alpha = 0.05)
      t = t_welch(other)
      td = TDistribution.new(compute_welch_df(other))
      t.abs < td.inverse_probability(1 - alpha.abs / 2.0)
    end

    # Return the confidence interval for the arithmetic mean with alpha level +alpha+ of
    # the elements of this Sequence instance as a Range object.
    def confidence_interval(alpha = 0.05)
      td = TDistribution.new(size - 1)
      t = td.inverse_probability(alpha / 2).abs
      delta = t * sample_standard_deviation / Math.sqrt(size)
      (arithmetic_mean - delta)..(arithmetic_mean + delta)
    end

    # Returns the array of autovariances (of length size - 1).
    def autovariance
      Array.new(size - 1) do |k|
        s = 0.0
        0.upto(size - k - 1) do |i|
          s += (@elements[i] - arithmetic_mean) * (@elements[i + k] - arithmetic_mean)
        end
        s / size
      end
    end

    # Returns the array of autocorrelation values c_k / c_0 (of length size -
    # 1).
    def autocorrelation
      c = autovariance
      Array.new(c.size) { |k| c[k] / c[0] }
    end

    # Returns the d-value for the Durbin-Watson statistic. The value is d << 2
    # for positive, d >> 2 for negative and d around 2 for no autocorrelation.
    def durbin_watson_statistic
      e = linear_regression.residues
      e.size <= 1 and return 2.0
      (1...e.size).inject(0.0) { |s, i| s + (e[i] - e[i - 1]) ** 2 } /
        e.inject(0.0) { |s, x| s + x ** 2 }
    end

    # Returns the q value of the Ljung-Box statistic for the number of lags
    # +lags+. A higher value might indicate autocorrelation in the elements of
    # this Sequence instance. This method returns nil if there weren't enough
    # (at least lags) lags available.
    def ljung_box_statistic(lags = 20)
      r = autocorrelation
      lags >= r.size and return
      n = size
      n * (n + 2) * (1..lags).inject(0.0) { |s, i| s + r[i] ** 2 / (n - i) }
    end

    # This method tries to detect autocorrelation with the Ljung-Box
    # statistic. If enough lags can be considered it returns a hash with
    # results, otherwise nil is returned. The keys are
    # :lags:: the number of lags,
    # :alpha_level:: the alpha level for the test,
    # :q:: the value of the ljung_box_statistic,
    # :p:: the p-value computed, if p is higher than alpha no correlation was detected,
    # :detected:: true if a correlation was found.
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

    # Return a result hash with the number of :very_low, :low, :high, and
    # :very_high outliers, determined by the box plotting algorithm run with
    # :median and :iqr parameters. If no outliers were found or the iqr is
    # less than epsilon, nil is returned.
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

    # Returns the LinearRegression object for the equation a * x + b which
    # represents the line computed by the linear regression algorithm.
    memoize method:
    def linear_regression
      LinearRegression.new @elements
    end

    # Returns a Histogram instance with +bins+ as the number of bins for this
    # analysis' elements.
    def histogram(bins)
      Histogram.new(self, bins)
    end
  end
end
