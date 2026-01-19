#!/usr/bin/env ruby

require 'test_helper'
require 'tins'

class EntropyTest < Test::Unit::TestCase
  include MoreMath::Functions

  def setup
    @empty  = ''
    @low    = ?A * 42
    @string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    @high   = 'The quick brown fox jumps over the lazy dog'
    @random = "\xAC-\x8A\xF5\xA8\xF7\\\e\xB5\x8CI\x06\xA7"
    @hi     = "こんにちは世界"
  end

  def test_entropy
    assert_equal 0, entropy(@empty)
    assert_equal 0, entropy(@low)
    assert_in_delta 3.951, entropy(@string), 1E-3
    assert_in_delta 4.431, entropy(@high), 1E-3
    assert_in_delta 3.700, entropy(@random), 1E-3
    assert_in_delta 2.807, entropy(@hi), 1E-3
  end

  def test_entropy_ideal
    assert_equal 0, entropy_ideal(-1)
    assert_equal 0, entropy_ideal(0)
    assert_equal 0, entropy_ideal(0.5)
    assert_equal 0, entropy_ideal(1)
    assert_in_delta 1,     entropy_ideal(2), 1E-3
    assert_in_delta 1.584, entropy_ideal(3), 1E-3
    assert_in_delta 3,     entropy_ideal(8), 1E-3
    assert_in_delta 3.321, entropy_ideal(10), 1E-3
    assert_in_delta 4,     entropy_ideal(16), 1E-3
  end

  def test_entropy_mamxium
    text = 'A' * 64
    assert_equal 0, entropy_maximum(text, size: -1)
    assert_equal 0, entropy_maximum(text, size: 0)
    assert_equal 0, entropy_maximum(text, size: 1)
    assert_equal 64, entropy_maximum(text, size: 2)
    assert_equal 256, entropy_maximum(text, size: 16)
    assert_equal 128, entropy_maximum(text[0, 32], size: 16)
  end

  def test_entropy_ratio
    assert_equal 0,        entropy_ratio(@empty)
    assert_equal 0,        entropy_ratio(@low, size: 128)
    assert_in_delta 0.564, entropy_ratio(@string, size: 128), 1E-3
    assert_in_delta 0.633, entropy_ratio(@high, size: 128), 1E-3
    assert_in_delta 1.0,   entropy_ratio(@random), 1E-3
    assert_in_delta 0.462, entropy_ratio(@random, size: 256), 1E-3
    assert_in_delta 0.253, entropy_ratio(@hi, size: 2_136), 1E-3
  end

  def test_entropy_ratio_minimum_basic
    # A fairly long random token over a 16‑symbol alphabet
    token = Tins::Token.new(length: 128, alphabet: Tins::Token::BASE16_LOWERCASE_ALPHABET)

    limit = entropy_ratio_minimum(token, size: 16)

    # Bounds must be ≧ 0
    assert_operator limit, :>=, 0.0

    # The observed ratio should be ≧ limit
    ratio = entropy_ratio(token, size: 16)
    assert_operator ratio, :>=, limit
  end

  def test_entropy_ratio_minimum_small
    # Very short string – the interval will stay below 1.0
    str = 'a'          # alphabet size 2 (binary)
    limit = entropy_ratio_minimum(str, size: 2)

    assert_equal 0.0, limit
  end
end
