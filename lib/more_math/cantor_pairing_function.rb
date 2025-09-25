module MoreMath
  # Provides Cantor pairing function implementations for encoding tuples into
  # natural numbers and decoding them back.
  #
  # The Cantor pairing function is a mathematical construct that uniquely
  # encodes pairs of natural numbers into a single natural number, and vice
  # versa. This module implements both the forward pairing function and its
  # inverse for arbitrary tuples of integers.
  #
  # @example Pairing two numbers
  #   CantorPairingFunction.cantor_pairing(5, 3) # => 39
  #
  # @example Pairing multiple numbers
  #   CantorPairingFunction.cantor_pairing(1, 2, 3) # => 69
  #
  # @example Inverse pairing
  #   CantorPairingFunction.cantor_pairing_inv(39) # => [5, 3]
  #
  # @example Inverse pairing for tuples
  #   CantorPairingFunction.cantor_pairing_inv(69, 3) # => [1, 2, 3]
  module CantorPairingFunction

    module_function

    # Encodes multiple integers into a single natural number using the Cantor
    # pairing function.
    #
    # This method implements the Cantor pairing function, which provides a
    # unique encoding of tuples of natural numbers into a single natural
    # number. For two integers, it uses the standard Cantor pairing formula.
    # For more than two integers, it recursively applies the pairing function
    # to reduce the tuple to a single value.
    #
    # @param xs [Array<Integer>] An array of integers to pair
    # @return [Integer] A unique natural number representing the input tuple
    # @raise [ArgumentError] When fewer than two arguments are provided
    def cantor_pairing(*xs)
      if xs.size == 1 and xs.first.respond_to?(:to_ary)
        xs = xs.first.to_ary
      end
      case xs.size
      when 0, 1
        raise ArgumentError, "at least two arguments are required"
      when 2
        x, y, = *xs
        (x + y) * (x + y + 1) / 2 + y
      else
        cantor_pairing(cantor_pairing(*xs[0..1]), *xs[2..-1])
      end
    end

    # Computes the cantor pairing function f(z) = z * (z + 1) / 2
    #
    # This helper method calculates a partial result used in the inverse cantor
    # pairing function to compute the triangular number sequence that helps in
    # decoding paired values
    #
    # @param z [Integer] The input value to compute the triangular number for
    # @return [Integer] The computed triangular number value
    def self.cantor_pairing_inv_f(z)
      z * (z + 1) / 2
    end

    # Computes the quotient used in the inverse Cantor pairing function
    #
    # This method calculates the largest value v such that the Cantor pairing
    # function applied to v is less than or equal to the given value z. It's a
    # helper method that supports the inverse pairing algorithm by determining
    # the appropriate triangular number boundary for decoding.
    #
    # @param z [Integer] The value to compute the quotient for
    # @return [Integer] The computed quotient value v where cantor_pairing_inv_f(v) <= z
    def self.cantor_pairing_inv_q(z)
      v = 0
      while cantor_pairing_inv_f(v) <= z
        v += 1
      end
      v - 1
    end

    # Computes the inverse of the Cantor pairing function for a given value
    #
    # This method decodes a natural number back into its original tuple
    # representation using the inverse Cantor pairing function. It supports
    # decoding tuples of arbitrary length by recursively applying the inverse
    # operation.
    #
    # @param c [Integer] The natural number to decode back into a tuple
    # @param n [Integer] The length of the original tuple (default: 2)
    # @return [Array<Integer>] The decoded tuple as an array of integers
    # @raise [ArgumentError] When n is less than 2
    def cantor_pairing_inv(c, n = 2)
      raise ArgumentError, "n is required to be >= 2" unless n >= 2
      result = []
      begin
        q = CantorPairingFunction.cantor_pairing_inv_q(c)
        y = c - CantorPairingFunction.cantor_pairing_inv_f(q)
        x = q - y
        result.unshift y
        c = x
        n -= 1
      end until n <= 1
      result.unshift x
    end
  end
end
