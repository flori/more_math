module MoreMath
  module Exceptions
    class MoreMathException < StandardError; end
    class DivergentException < MoreMathException ; end
  end
end
