#!/usr/bin/env ruby

require 'test_helper'
require 'tins'

class EntropyTest < Test::Unit::TestCase
  include MoreMath::Functions

  # The setup method initializes instance variables with various string values.
  #
  # This method prepares the object with predefined string constants for
  # testing and demonstration purposes. It sets up empty strings, strings of
  # specific lengths, and strings containing various character sets
  # including ASCII, Unicode, and Japanese characters.
  def setup
    @empty  = ''
    @low    = ?A * 42
    @string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    @high   = 'The quick brown fox jumps over the lazy dog'
    @random = "\xAC-\x8A\xF5\xA8\xF7\\\e\xB5\x8CI\x06\xA7"
    @hi     = "こんにちは世界"
  end

  def test_entropy
    assert_in_delta 0.0, entropy(@empty), 1e-12
    assert_in_delta 0.0, entropy(@low),    1e-12
    assert_in_delta 3.951, entropy(@string), 1e-3
    assert_in_delta 4.431, entropy(@high),   1e-3
    assert_in_delta 3.700, entropy(@random), 1e-3
    assert_in_delta 2.807, entropy(@hi),     1e-3
  end

  def test_entropy_ideal
    assert_in_delta 0.0, entropy_ideal(-1), 1e-12
    assert_in_delta 0.0, entropy_ideal(0),  1e-12
    assert_in_delta 0.0, entropy_ideal(0.5), 1e-12
    assert_in_delta 0.0, entropy_ideal(1),  1e-12
    assert_in_delta 1.0,   entropy_ideal(2), 1e-3
    assert_in_delta 1.584, entropy_ideal(3), 1e-3
    assert_in_delta 3.0,   entropy_ideal(8), 1e-3
    assert_in_delta 3.321, entropy_ideal(10), 1e-3
    assert_in_delta 4.0,   entropy_ideal(16), 1e-3
  end

  def test_entropy_maximum
    text = 'A' * 64
    assert_equal 0, entropy_maximum(text, size: -1)
    assert_equal 0, entropy_maximum(text, size: 0)
    assert_equal 0, entropy_maximum(text, size: 1)
    assert_equal 64, entropy_maximum(text, size: 2)
    assert_equal 256, entropy_maximum(text, size: 16)
    assert_equal 128, entropy_maximum(text[0, 32], size: 16)
  end

  def test_entropy_ratio
    assert_in_delta 0.0, entropy_ratio(@empty, size: 128), 1e-12
    assert_in_delta 0.0, entropy_ratio(@low, size: 128), 1e-12
    assert_in_delta 0.564, entropy_ratio(@string, size: 128), 1e-3
    assert_in_delta 0.633, entropy_ratio(@high, size: 128), 1e-3
    assert_in_delta 1.0,   entropy_ratio(@random, size: @random.size), 1e-3
    assert_in_delta 0.462, entropy_ratio(@random, size: 256), 1e-3
    assert_in_delta 0.253, entropy_ratio(@hi, size: 2_136), 1e-3
  end

  def test_entropy_probabilities
    probs = entropy_probabilities('ABAB')
    assert_equal 0.5, probs['A']
    assert_equal 0.5, probs['B']

    probs = entropy_probabilities('AAAA')
    assert_equal 1.0, probs['A']

    probs = entropy_probabilities([])
    assert_equal({}, probs)

    # Ensure the method accepts an Array of symbols
    probs = entropy_probabilities(['x', 'y', 'x'])
    assert_equal 2.0 / 3.0, probs['x']
    assert_equal 1.0 / 3.0, probs['y']
  end

  def test_minimum_entropy_per_symbol
    # Uniform distribution → entropy equals log2(size)
    assert_in_delta 2.0, minimum_entropy_per_symbol('ABCD'), 1e-12

    # Single symbol → 0
    assert_in_delta 0.0, minimum_entropy_per_symbol('AAAA'), 1e-12

    # Empty string → 0
    assert_in_delta 0.0, minimum_entropy_per_symbol(''), 1e-12
  end

  def test_collision_entropy_per_symbol
    # For a uniform distribution, collision entropy = log2(size)
    assert_in_delta 2.0, collision_entropy_per_symbol('ABCD'), 1e-12

    # All symbols the same → 0
    assert_in_delta 0.0, collision_entropy_per_symbol('AAAA'), 1e-12

    # Empty string → 0
    assert_in_delta 0.0, collision_entropy_per_symbol(''), 1e-12
  end

  def test_entropy_total
    text = 'ABCD'
    per = entropy_per_symbol(text)
    assert_in_delta per * text.size, entropy_total(text), 1e-12

    assert_in_delta 0.0, entropy_total(''), 1e-12
  end

  def test_minimum_entropy_total
    text = 'ABCD'
    per = minimum_entropy_per_symbol(text)
    assert_in_delta per * text.size, minimum_entropy_total(text), 1e-12

    assert_in_delta 0.0, minimum_entropy_total(''), 1e-12
  end

  def test_collision_entropy_total
    text = 'ABCD'
    per = collision_entropy_per_symbol(text)
    assert_in_delta per * text.size, collision_entropy_total(text), 1e-12

    assert_in_delta 0.0, collision_entropy_total(''), 1e-12
  end
end
