#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class EntropyTest < Test::Unit::TestCase
  include MoreMath::Functions

  def setup
    @empty  = ''
    @low    = ?A * 42
    @string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    @high   = 'The quick brown fox jumps over the lazy dog'
    @random = "\xAC-\x8A\xF5\xA8\xF7\\\e\xB5\x8CI\x06\xA7"
  end

  def test_entropy
    assert_equal 0, entropy(@empty)
    assert_equal 0, entropy(@low)
    assert_in_delta 3.9514, entropy(@string), 1E-3
    assert_in_delta 4.4319, entropy(@high), 1E-3
    assert_in_delta 3.700, entropy(@random), 1E-3
  end

  def test_entropy_ideal
    assert_equal 0, entropy_ideal(-1)
    assert_equal 0, entropy_ideal(0)
    assert_equal 0, entropy_ideal(0.5)
    assert_equal 0, entropy_ideal(1)
    assert_in_delta 1, entropy_ideal(2), 1E-3
    assert_in_delta 1.584, entropy_ideal(3), 1E-3
    assert_in_delta 3, entropy_ideal(8), 1E-3
    assert_in_delta 3.321, entropy_ideal(10), 1E-3
    assert_in_delta 4, entropy_ideal(16), 1E-3
  end

  def test_entropy_percentage
    assert_equal 0, entropy_percentage(@empty)
    assert_equal 0, entropy_percentage(@low)
    assert_in_delta 0.6834, entropy_percentage(@string), 1E-3
    assert_in_delta 0.8167, entropy_percentage(@high), 1E-3
    assert_in_delta 1.0, entropy_percentage(@random), 1E-3
  end
end
