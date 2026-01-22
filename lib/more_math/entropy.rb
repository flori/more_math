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
    # Calculates the probability distribution of symbols in the given input.
    #
    # This method computes the frequency of each symbol in the input and
    # converts these frequencies into probabilities by dividing by the total
    # number of symbols.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate probabilities for
    # @return [Hash<String, Float>] A hash mapping each symbol to its
    #   probability value
    def entropy_probabilities(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      freq  = symbols.tally
      total = symbols.size

      freq.transform_values { |c| c.to_f / total }
    end

    # Calculates the Shannon entropy per symbol in the given symbols.
    #
    # This method computes the entropy of a sequence of symbols, measuring the
    # average information content or unpredictability of the symbols.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to calculate entropy for
    # @return [Float] The entropy value in bits per symbol
    def entropy_per_symbol(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      symbols.empty? and return 0.0

      probs = entropy_probabilities(symbols)

      -probs.values.sum { |p| p * Math.log2(p) }
    end
    alias entropy entropy_per_symbol

    # Calculates the minimum entropy per symbol in the given symbols.
    #
    # This method determines the minimum possible entropy for a sequence of
    # symbols, which represents the entropy when all symbols are equally
    # likely.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate minimum entropy for
    # @return [Float] The minimum entropy value in bits per symbol
    def minimum_entropy_per_symbol(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      symbols.empty? and return 0.0

      probs = entropy_probabilities(symbols)

      -Math.log2(probs.values.max)
    end

    # Calculates the collision entropy per symbol in the given symbols.
    #
    # This method computes the collision entropy, which measures the
    # unpredictability of the most likely outcome in a symbol sequence. It's
    # based on the sum of squared probabilities of each symbol.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate collision entropy for
    # @return [Float] The collision entropy value in bits per symbol
    def collision_entropy_per_symbol(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      symbols.empty? and return 0.0

      probs = entropy_probabilities(symbols)

      -Math.log2(probs.values.sum { |p| p * p })
    end

    # Calculates the total entropy for a sequence of symbols.
    #
    # This method computes the total information content of a symbol sequence
    # by multiplying the entropy per symbol by the total number of symbols.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate total entropy for
    # @return [Float] The total entropy value in bits for the entire symbol
    #   sequence
    def entropy_total(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      entropy_per_symbol(symbols) * symbols.size
    end

    # Calculates the total minimum entropy for a sequence of symbols.
    #
    # This method computes the total information content of a symbol sequence
    # using the minimum entropy per symbol, multiplied by the total number of
    # symbols. It represents the theoretical minimum possible entropy for the
    # given sequence.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate total minimum entropy for
    # @return [Float] The total minimum entropy value in bits for the entire
    #   symbol sequence
    def minimum_entropy_total(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      minimum_entropy_per_symbol(symbols) * symbols.size
    end

    # Calculates the total collision entropy for a sequence of symbols.
    #
    # This method computes the total information content of a symbol sequence
    # using the collision entropy per symbol, multiplied by the total number of
    # symbols. Collision entropy measures the unpredictability of the most
    # likely outcome in a symbol sequence.
    #
    # @param symbols [String, Array<String>] The sequence of symbols to
    #   calculate total collision entropy for
    # @return [Float] The total collision entropy value in bits for the entire
    #   symbol sequence
    def collision_entropy_total(symbols)
      symbols = symbols.chars if symbols.respond_to?(:chars)

      collision_entropy_per_symbol(symbols) * symbols.size
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
    #
    # @param text [String] The input text to calculate entropy ratio for
    # @param size [Integer] The size of the character set to normalize against
    #   (alphabet size).
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
