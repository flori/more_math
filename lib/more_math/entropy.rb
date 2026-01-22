module MoreMath
  # Provides entropy calculation utilities for measuring information content
  # and randomness in text data.
  #
  # This module implements Shannon entropy calculations to quantify the
  # unpredictability or information content of text strings. It's commonly used
  # in cryptography, data compression, and information theory applications.
  #
  # The entropy measures help determine how "random" or "predictable" a text is,
  # which can be useful for:
  # - Password strength analysis
  # - Data compression efficiency estimation
  # - Cryptographic security assessment
  # - Text analysis and classification
  #
  # @example Basic usage
  #   require 'more_math'
  #   include MoreMath::Functions
  #
  #   text = "hello world"
  #   puts entropy(text)        # => 2.3219280948873626
  #   puts entropy_ratio(text)   # => 0.7428571428571429
  #
  # @example Using with different text samples
  #   entropy("aaaa")           # => 0.0 (no entropy)
  #   entropy("abcd")           # => 2.0 (actual entropy)
  module Entropy
    # Calculates the Shannon entropy in bits of a text string.
    #
    # Shannon entropy measures the average amount of information (in bits) needed
    # to encode characters in the text based on their frequencies.
    #
    # @example
    #   entropy("hello") # => 2.3219280948873626
    #   entropy("aaaa")  # => 0.0
    #
    # @param text [String] The input text to calculate entropy for
    # @return [Float] The Shannon entropy in bits
    def entropy(text)
      chars = nil
      if text.respond_to?(:chars)
        chars = text.chars
      else
        chars = text
      end
      size  = chars.size

      chars.each_with_object(Hash.new(0.0)) { |c, h| h[c] += 1 }.
        each_value.reduce(0.0) do |entropy, count|
          frequency = count / size
          entropy + frequency * Math.log2(frequency)
        end.abs
    end

    # Calculates the ideal (maximum) entropy for a given character set size.
    #
    # This represents the maximum possible entropy when all characters in the
    # alphabet have equal probability of occurrence.
    #
    # @example
    #   entropy_ideal(2)  # => 1.0
    #   entropy_ideal(256) # => 8.0
    #
    # @param size [Integer] The number of unique characters in the alphabet
    # @return [Float] The maximum possible entropy in bits
    def entropy_ideal(size)
      size <= 1 and return 0.0
      frequency = 1.0 / size
      -1.0 * size * frequency * Math.log2(frequency)
    end

    # Calculates the normalized entropy ratio of a text string.
    #
    # The ratio is calculated as actual entropy divided by ideal entropy,
    # giving a value between 0 and 1 where:
    # - 0 indicates no entropy (all characters are identical)
    # - 1 indicates maximum entropy (uniform distribution across the alphabet)
    #
    # The normalization uses the specified alphabet size to calculate the
    # theoretical maximum entropy for that character set.
    #
    # @example
    #   entropy_ratio("hello", size: 26) # => 0.4088
    #   entropy_ratio("aaaaa", size: 26) # => 0.0
    #   entropy_ratio("abcde", size: 5)  # => 1.0
    #   entropy_ratio("abcde", size: 26) # => 0.4939
    #
    # @param text [String] The input text to calculate entropy ratio for
    # @param size [Integer] The size of the character set to normalize against (alphabet size).
    # @return [Float] Normalized entropy ratio between 0 and 1
    def entropy_ratio(text, size:)
      size <= 1 and return 0.0
      entropy(text) / entropy_ideal(size)
    end

    # Calculates the maximum possible entropy for a given text and alphabet
    # size.
    #
    # This represents the theoretical maximum entropy that could be achieved if
    # all characters in the text were chosen uniformly at random from the
    # alphabet. It's used to determine the upper bound of security strength for
    # tokens.
    #
    # @example
    #   entropy_maximum("hello", size: 26)  # => 23
    #   entropy_maximum("abc123", size: 64) # => 36
    #
    # @param text [String] The input text to calculate maximum entropy for
    # @param size [Integer] The size of the character set (alphabet size)
    # @return [Integer] The maximum possible entropy in bits, or 0 if size <= 1
    def entropy_maximum(text, size:)
      size > 1 or return 0
      (text.size * Math.log2(size)).floor
    end
  end
end
