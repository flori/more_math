module MoreMath
  # This class computes a linear regression for the given image and domain data
  # sets.
  class LinearRegression
    def initialize(image, domain = (0...image.size).to_a)
      image.size != domain.size and raise ArgumentError,
        "image and domain have unequal sizes"
      @image, @domain = image, domain
      compute
    end

    # The image data as an array.
    attr_reader :image

    # The domain data as an array.
    attr_reader :domain

    # The slope of the line.
    attr_reader :a

    # The offset of the line.
    attr_reader :b

    # Return true if the slope of the underlying data (not the sample data
    # passed into the constructor of this LinearRegression instance) is likely
    # (with alpha level _alpha_) to be zero.
    def slope_zero?(alpha = 0.05)
      df = @image.size - 2
      return true if df <= 0 # not enough values to check
      t = tvalue(alpha)
      td = TDistribution.new df
      t.abs <= td.inverse_probability(1 - alpha.abs / 2.0).abs
    end

    # Returns the residuals of this linear regression in relation to the given
    # domain and image.
    def residuals
      result = []
      @domain.zip(@image) do |x, y|
        result << y - (@a * x + @b)
      end
      result
    end

    def r2
      image_seq = MoreMath::Sequence.new(@image)
      sum_res   = residuals.inject(0.0) { |s, r| s + r ** 2 }
      [
        1.0 -  sum_res / image_seq.sum_of_squares,
        0.0,
      ].max
    end

    private

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

    def tvalue(alpha = 0.05)
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
