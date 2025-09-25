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
  #   include MoreMath
  #
  #   text = "hello world"
  #   puts entropy(text)        # => 2.3219280948873626
  #   puts entropy_ratio(text)   # => 0.7428571428571429
  #
  # @example Using with different text samples
  #   MoreMath::Entropy.entropy("aaaa")           # => 0.0 (no entropy)
  #   MoreMath::Entropy.entropy("abcd")           # => 2.0 (maximum entropy)
  module Entropy
    # Calculates the Shannon entropy of a text string.
    #
    # Shannon entropy measures the average amount of information (in bits) needed
    # to encode characters in the text based on their frequencies.
    #
    # @example
    #   MoreMath::Entropy.entropy("hello") # => 2.3219280948873626
    #   MoreMath::Entropy.entropy("aaaa")  # => 0.0
    #
    # @param text [String] The input text to calculate entropy for
    # @return [Float] The Shannon entropy in bits
    def entropy(text)
      chars = text.chars
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
    #   MoreMath::Entropy.entropy_ideal(2)  # => 1.0
    #   MoreMath::Entropy.entropy_ideal(256) # => 8.0
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
    #   MoreMath::Entropy.entropy_ratio("hello")     # => 0.6834
    #   MoreMath::Entropy.entropy_ratio("aaaaa")     # => 0.0
    #   MoreMath::Entropy.entropy_ratio("abcde")     # => 1.0
    #
    # @example With custom alphabet size
    #   # Normalizing against a 26-letter alphabet (English)
    #   MoreMath::Entropy.entropy_ratio("hello", size: 26) # => 0.394...
    #
    # @param text [String] The input text to calculate entropy ratio for
    # @param size [Integer] The size of the character set to normalize against.
    #   Defaults to the total length of the text (`text.each_char.size`), which
    #   normalizes the entropy relative to the text's own character space.
    #   This allows comparison of texts with different lengths on the same scale.
    # @return [Float] Normalized entropy ratio between 0 and 1
    def entropy_ratio(text, size: text.each_char.size)
      size <= 1 and return 0.0
      entropy(text) / entropy_ideal(size)
    end
  end
end
