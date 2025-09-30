# MoreMath - More mathematics in Ruby

## Description

Ruby library that contains various mathematical functions and algorithms,
extending Ruby's capabilities in domains such as statistics, numerical
analysis, and combinatorics.

MoreMath provides a comprehensive set of mathematical tools including:
- Advanced mathematical functions (gamma, beta, error functions)
- Mathematical constants and precision utilities
- Statistical distributions and hypothesis testing
- Sequence analysis and time series operations
- Combinatorial algorithms (permutations, subsets)
- Special functions (continued fractions, Cantor pairing)
- Data visualization tools (histograms)
- String numeral conversion and Gödel numbering
- Numerical integration methods
- Statistical quality control tools
- Information theory calculations

## Documentation

Complete API documentation is available at: [GitHub.io](https://flori.github.io/more_math/)

## Example Usage

```ruby
include MoreMath::Functions # include like you would ::Math

# Compute the gamma function at 0.5
puts gamma(0.5) # => 1.77245385091

# Define a continued fraction representation of the arctangent function (atan)
atan = ContinuedFraction.for_a do |n, x|
  n == 0 ? 0 : 2 * n - 1
end.for_b do |n, x|
  n <= 1 ? x : ((n - 1) * x) ** 2
end
pi = -> (epsilon: 1E-16) { 4 * atan.(1, epsilon:) }
puts pi.() # => 3.1415926535897936

# Compute the moving average of an array
sequence = [1, 2, 3, 4, 5]
ma = Sequence.new(sequence).simple_moving_average(2)
puts ma.inspect # => [1.5, 2.5, 3.5, 4.5]

# Create a histogram with 3 bins, display it in on STDOUT with a width of 80 characters
Histogram.new([1, 2, 3, 4, 5, 1], bins: 3).display(STDOUT, 80) ; nil
#   4.33333 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
#   3.00000 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
#   1.66667 -|⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
```

## Installation

### Using RubyGems
```bash
gem install more_math
```

### Using Bundler
Add to your Gemfile:
```ruby
gem 'more_math'
```

## Author

[Florian Frank](mailto:flori@ping.de)

## License

This software is licensed under the [MIT License](./LICENSE).

## Homepage

The homepage of this library is located at:

* http://github.com/flori/more_math
