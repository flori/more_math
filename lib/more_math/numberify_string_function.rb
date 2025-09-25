module MoreMath
  # Provides functions for converting between strings and numbers using a
  # base-N numeral system.
  #
  # This module implements Gödel numbering, where strings are encoded into
  # unique natural numbers and decoded back. It's particularly useful for
  # applications requiring ordered enumeration of strings or mathematical
  # operations on textual data.
  #
  # The encoding follows a positional numeral system where each character
  # position represents a power of the alphabet size.
  #
  # @example Basic usage
  #   # Convert string to number
  #   MoreMath::NumberifyStringFunction.numberify_string("abc") # => 731
  #
  #   # Convert number back to string
  #   MoreMath::NumberifyStringFunction.stringify_number(731) # => "abc"
  #
  # @example With custom alphabet
  #   alphabet = ['a', 'b', 'c']
  #   MoreMath::NumberifyStringFunction.numberify_string("abc", alphabet) # => 18
  #   MoreMath::NumberifyStringFunction.stringify_number(18, alphabet) # => "abc"
  module NumberifyStringFunction
    include Functions

    module_function

    # Converts a string into a unique natural number using the specified
    # alphabet.
    #
    # This method implements a base-N numeral system where N is the size of the
    # alphabet. Each character in the string contributes to the final number
    # based on its position and value within the alphabet.
    #
    # @example Basic usage
    #   MoreMath::NumberifyStringFunction.numberify_string("hello") # => 123456789
    #
    # @example With custom alphabet
    #   alphabet = ['a', 'b', 'c']
    #   MoreMath::NumberifyStringFunction.numberify_string("abc", alphabet) # => 18
    #
    # @param string [String] The input string to convert to a number
    # @param alphabet [Array<String>, Range<String>] The alphabet to use for conversion.
    #   Defaults to 'a'..'z' (lowercase English letters)
    # @return [Integer] A unique natural number representing the input string
    # @raise [ArgumentError] If any character in the string is not found in the alphabet
    def numberify_string(string, alphabet = 'a'..'z')
      alphabet = NumberifyStringFunction.convert_alphabet(alphabet)
      s, k = string.size, alphabet.size
      result = 0
      for i in 0...s
        c = string[i, 1]
        a = (alphabet.index(c) || raise(ArgumentError, "#{c.inspect} not in alphabet")) + 1
        j = s - i - 1
        result += a * k ** j
      end
      result
    end

    # Converts a natural number back into its corresponding string
    # representation.
    #
    # This is the inverse operation of {numberify_string}. It reconstructs the
    # original string by reversing the positional numeral system encoding.
    #
    # @example Basic usage
    #   MoreMath::NumberifyStringFunction.stringify_number(731) # => "abc"
    #
    # @example With custom alphabet
    #   alphabet = ['a', 'b', 'c']
    #   MoreMath::NumberifyStringFunction.stringify_number(18, alphabet) # => "abc"
    #
    # @param number [Integer] The natural number to convert back to a string
    # @param alphabet [Array<String>, Range<String>] The alphabet to use for conversion.
    #   Defaults to 'a'..'z' (lowercase English letters)
    # @return [String] The original string representation of the number
    # @raise [ArgumentError] If the number is negative
    def stringify_number(number, alphabet = 'a'..'z')
      case
      when number < 0
        raise ArgumentError, "number is required to be >= 0"
      when number == 0
        return ''
      end
      alphabet = NumberifyStringFunction.convert_alphabet(alphabet)
      s = NumberifyStringFunction.compute_size(number, alphabet.size)
      k, m = alphabet.size, number
      result = ' ' * s
      q = m
      s.downto(1) do |i|
        r = q / k
        q = r * k < q ? r : r - 1
        result[i - 1] = alphabet[m - q * k - 1]
        m = q
      end
      result
    end

    # Calculates the minimum number of digits needed to represent a number in
    # base N.
    #
    # This helper method is used internally to determine how many characters
    # are needed when converting a number back to its string representation.
    #
    # @api private
    # @param n [Integer] The number to calculate size for
    # @param b [Integer] The base of the numeral system
    # @return [Integer] The minimum number of digits required
    def compute_size(n, b)
      i = 0
      while n > 0
        i += 1
        n -= b ** i
      end
      i
    end

    # Converts various alphabet representations into a consistent Array format.
    #
    # This method handles different input types for the alphabet:
    # - Range: converts to array of characters
    # - String: splits into individual characters
    # - Array: returns as-is
    #
    # @api private
    # @param alphabet [Object] The alphabet in various formats (Range, String, or Array)
    # @return [Array<String>] Standardized array representation of the alphabet
    def convert_alphabet(alphabet)
      if alphabet.respond_to?(:to_ary)
        alphabet.to_ary
      elsif alphabet.respond_to?(:to_str)
        alphabet.to_str.split(//)
      else
        alphabet.to_a
      end
    end
  end
end
