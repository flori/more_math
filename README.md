# MoreMath - More mathematics in Ruby

## Description

Ruby library that contains various mathematical functions and algorithms,
extending Ruby's capabilities in domains such as statistics, numerical
analysis, and combinatorics.

### Core Features

1. **Mathematical Functions**
   - **Gamma Function**: Computes the gamma function for real numbers.
   - **Beta Function**: Calculates the beta function and its regularized form.
   - **Error Function (erf)**: Provides the error function used in probability
     and statistics.

2. **Special Functions**
   - **Lambert W Function**: Solves equations of the form `x = a * exp(x)`.
   - **Continued Fractions**: Evaluates continued fractions for various
     mathematical expressions.

3. **Statistical Tools**
   - **Probability Distributions**: Implements distributions like Student's t,
     chi-squared, and Fisher's z.
   - **Random Number Generation**: Generates random numbers following specific
     distributions.
   - **Hypothesis Testing**: Performs tests like the Kolmogorov-Smirnov test
     for distribution comparison.

4. **Sequence Analysis**
   - **Moving Averages**: Computes simple moving averages for time series data.
   - **Autocorrelation and Autovariance**: Analyzes the correlation structure
     of sequences.
   - **Histograms**: Visualizes data distributions with customizable bins.

5. **Combinatorics and Algorithms**
   - **Permutations and Combinations**: Generates permutations, combinations,
     and Cartesian products.
   - **Graph Theory**: Includes algorithms for shortest paths (Dijkstra,
     Floyd-Warshall) and minimum spanning trees.
   - **Root Finding**: Uses Newton-Raphson and bisection methods to find roots
     of functions.

### Specialized Modules

1. **String Numeral Conversion**
   - Converts strings to Gödel numbers and vice versa using a specified
   alphabet.

2. **Cantor Pairing Function**
   - Encodes tuples into a single integer and decodes them back, useful in set
   theory and combinatorics.

3. **Histograms**
   - Creates histograms for data visualization with support for different
   binning strategies.

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

To install `more_math`, run:

```bash
gem install more_math
```

## Author

Florian Frank  
mailto:flori@ping.de

## License

This software is licensed under the X11 (or MIT) license:
http://www.xfree86.org/3.3.6/COPYRIGHT2.html#3

## Homepage

The homepage of this library is located at:

* http://github.com/flori/more_math
