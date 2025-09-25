module MoreMath
  # Module containing custom exception classes for the MoreMath library
  module Exceptions
    # Base exception class for all MoreMath exceptions
    #
    # All custom exceptions in the MoreMath library inherit from this class
    #
    # @example Handling a MoreMath exception
    #   begin
    #     # Some MoreMath operation
    #   rescue MoreMath::Exceptions::MoreMathException => e
    #     puts "MoreMath error: #{e.message}"
    #   end
    class MoreMathException < StandardError; end

    # Exception raised when a mathematical computation diverges or fails to converge
    #
    # This exception is typically raised when numerical methods fail to produce
    # meaningful results due to divergence, such as:
    # - Non-converging series expansions
    # - Divergent continued fractions
    # - Failed root finding algorithms
    #
    # @example Handling a divergent computation
    #   begin
    #     # Some divergent operation
    #   rescue MoreMath::Exceptions::DivergentException => e
    #     puts "Computation diverged: #{e.message}"
    #   end
    class DivergentException < MoreMathException ; end
  end
end
