module MoreMath
  unless defined?(::MoreMath::Infinity) == 'constant'
    Infinity = 1.0 / 0      # Refers to floating point infinity.
  end

  require 'more_math/cantor_pairing_function'
  require 'more_math/constants/functions_constants'
  require 'more_math/continued_fraction'
  require 'more_math/distributions'
  require 'more_math/exceptions'
  require 'more_math/functions'
  require 'more_math/histogram'
  require 'more_math/linear_regression'
  require 'more_math/newton_bisection'
  require 'more_math/numberify_string_function'
  require 'more_math/sequence'
  require 'more_math/string_numeral'
  require 'more_math/power_set'
  require 'more_math/version'
end
