module MoreMath
  # This class computes a linear regression for the given image and domain data
  # sets.
  #
  # Linear regression is a statistical method that models the relationship
  # between a dependent variable (image) and one or more independent variables
  # (domain). It fits a linear equation to observed data points to make
  # predictions or understand relationships.
  #
  # The implementation uses the least squares method to find the best-fit line
  # y = ax + b, where 'a' is the slope and 'b' is the y-intercept.
  #
  # @example Basic usage
  #   # Create a linear regression from data points
  #   image_data = [2, 4, 6, 8, 10]
  #   domain_data = [1, 2, 3, 4, 5]
  #   lr = LinearRegression.new(image_data, domain_data)
  #
  #   # Access the fitted line parameters
  #   puts lr.a  # slope
  #   puts lr.b  # y-intercept
  #
  #   # Make predictions
  #   predicted_y = lr.a * 6 + lr.b  # Predict y for x=6
  #
  # @example Statistical analysis
  #   # Check if the slope is significantly different from zero
  #   lr.slope_zero?(0.05)  # Returns true if slope is not statistically significant
  #
  #   # Calculate coefficient of determination (R²)
  #   puts lr.r2  # R-squared value indicating model fit
  class LinearRegression
    # Creates a new LinearRegression instance with image and domain data.
    #
    # Initializes the linear regression model using the provided data points.
    # The domain data represents independent variables (x-values) and the image
    # data represents dependent variables (y-values).
    #
    # @param image [Array<Numeric>] Array of dependent variable values (y-coordinates)
    # @param domain [Array<Numeric>] Array of independent variable values (x-coordinates)
    # @raise [ArgumentError] If image and domain arrays have unequal sizes
    # @example Creating a linear regression
    #   image = [1, 2, 3, 4, 5]
    #   domain = [0, 1, 2, 3, 4]
    #   lr = LinearRegression.new(image, domain)
    def initialize(image, domain = (0...image.size).to_a)
      image.size != domain.size and raise ArgumentError,
        "image and domain have unequal sizes"
      @image, @domain = image, domain
      compute
    end

    # The image data as an array.
    #
    # Returns the dependent variable values used in the regression.
    #
    # @return [Array<Numeric>] Array of y-values from the original data
    attr_reader :image

    # The domain data as an array.
    #
    # Returns the independent variable values used in the regression.
    #
    # @return [Array<Numeric>] Array of x-values from the original data
    attr_reader :domain

    # The slope of the line.
    #
    # Returns the calculated slope (a) of the best-fit line y = ax + b.
    #
    # @return [Float] The slope coefficient of the linear regression
    attr_reader :a

    # The offset of the line.
    #
    # Returns the calculated y-intercept (b) of the best-fit line y = ax + b.
    #
    # @return [Float] The y-intercept coefficient of the linear regression
    attr_reader :b

    # Checks if the slope is significantly different from zero.
    #
    # Performs a t-test to determine whether the slope coefficient is
    # statistically significant at the given significance level (alpha).
    # This test helps determine if there's a meaningful linear relationship
    # between the independent and dependent variables.
    #
    # @param alpha [Float] The significance level (default: 0.05, or 5%)
    # @return [Boolean] true if the slope is not significantly different from zero,
    #   false otherwise
    # @raise [ArgumentError] If alpha is not in the range 0..1
    # @example Testing slope significance
    #   lr = LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 6, 8, 10])
    #   lr.slope_zero?  # => false (slope is significantly different from zero)
    #   lr.slope_zero?(0.1)  # => false (still significant at 10% level)
    def slope_zero?(alpha = 0.05)
      (0..1) === alpha or raise ArgumentError, 'alpha should be in 0..100'
      df = @image.size - 2
      return true if df <= 0 # not enough values to check
      t = tvalue
      td = TDistribution.new df
      t.abs <= td.inverse_probability(1 - alpha.abs / 2.0).abs
    end

    # Returns the residuals of this linear regression.
    #
    # Residuals are the differences between observed values and predicted
    # values from the regression line. They represent the error in prediction
    # for each data point.
    #
    # @return [Array<Float>] Array of residual values (observed - predicted)
    # @example Calculating residuals
    #   lr = LinearRegression.new([1, 2, 3], [0, 1, 2])
    #   puts lr.residuals  # [0.0, 0.0, 0.0] for perfect fit
    def residuals
      result = []
      @domain.zip(@image) do |x, y|
        result << y - (@a * x + @b)
      end
      result
    end

    # Returns the coefficient of determination (R²).
    #
    # R² measures the proportion of the variance in the dependent variable that is
    # predictable from the independent variable(s). It ranges from 0 to 1, where
    # higher values indicate better fit.
    #
    # @return [Float] The R-squared value (0.0 to 1.0)
    # @example Checking model fit
    #   lr = LinearRegression.new([1, 2, 3], [0, 1, 2])
    #   puts lr.r2  # 1.0 for perfect linear relationship
    def r2
      image_seq = MoreMath::Sequence.new(@image)
      sum_res   = residuals.inject(0.0) { |s, r| s + r ** 2 }
      [
        1.0 -  sum_res / image_seq.sum_of_squares,
        0.0,
      ].max
    end

    private

    # Computes the linear regression parameters using least squares method.
    #
    # This internal method calculates the slope (a) and intercept (b)
    # coefficients by solving the normal equations derived from minimizing the
    # sum of squared residuals.
    #
    # @return [self] Returns self to allow method chaining
    def compute
      size = @image.size
      sum_xx = sum_xy = sum_x = sum_y = 0.0
      @domain.zip(@image) do |x, y|
        sum_xx += x ** 2
        sum_xy += x * y
        sum_x += x
        sum_y += y
      end
      @a = (size * sum_xy - sum_x * sum_y) / (size * sum_xx - sum_x ** 2)
      @b = (sum_y - @a * sum_x) / size
      self
    end

    # Calculates the t-value for testing slope significance.
    #
    # This internal method computes the t-statistic used in hypothesis testing
    # to determine if the slope differs significantly from zero.
    #
    # @return [Float] The calculated t-value for the test
    def tvalue
      df = @image.size - 2
      return 0.0 if df <= 0
      sse_y = 0.0
      @domain.zip(@image) do |x, y|
        f_x = a * x + b
        sse_y += (y - f_x) ** 2
      end
      mean = @image.inject(0.0) { |s, y| s + y } / @image.size
      sse_x = @domain.inject(0.0) { |s, x| s + (x - mean) ** 2 }
      t = a / (Math.sqrt(sse_y / df) / Math.sqrt(sse_x))
      t.nan? ? 0.0 : t
    end
  end
end
