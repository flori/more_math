#!/usr/bin/env ruby

require 'test/unit'
require 'more_math'

class TestNumerateStringFunction < Test::Unit::TestCase
  include MoreMath::Functions

  def logb(x, b = 2)
    Math.log(x) / Math.log(b)
  end

  def test_log_ceil
    assert_raise(ArgumentError) { log_ceil(-1) }
    assert_raise(ArgumentError) { log_ceil(0) }
    for x in 1..256
      assert_equal logb(x).ceil, log_ceil(x), "log_ceil(#{x}) failed"
    end
  end

  def test_log_floor
    assert_raise(ArgumentError) { log_floor(-1) }
    assert_raise(ArgumentError) { log_floor(0) }
    for x in 1..256
      assert_equal logb(x).floor, log_floor(x), "log_floor(#{x}) failed"
    end
  end

  def test_numerate_string_function
    assert_equal 0, numerate_string('', 'ab')
    assert_equal 1, numerate_string('a', 'ab')
    assert_equal 2, numerate_string('b', 'ab')
    assert_equal 3, numerate_string('aa', 'ab')
    assert_equal 4, numerate_string('ab', 'ab')
    assert_equal 5, numerate_string('ba', 'ab')
    assert_equal 6, numerate_string('bb', 'ab')
  end

  def test_numerate_string_inv_function
    assert_raise(ArgumentError) { numerate_string_inv(-1, 'ab') }
    assert_equal '', numerate_string_inv(0, 'ab')
    assert_equal 'a', numerate_string_inv(1, 'ab')
    assert_equal 'b', numerate_string_inv(2, 'ab')
    assert_equal 'aa', numerate_string_inv(3, 'ab')
    assert_equal 'ab', numerate_string_inv(4, 'ab')
    assert_equal 'ba', numerate_string_inv(5, 'ab')
    assert_equal 'bb', numerate_string_inv(6, 'ab')
  end
end
