#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class NumberifyStringFunctionTest < Test::Unit::TestCase
  include MoreMath::Functions

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

  def test_numberify_string_function
    assert_equal 0, numberify_string('', 'ab')
    assert_equal 1, numberify_string('a', 'ab')
    assert_equal 2, numberify_string('b', 'ab')
    assert_equal 3, numberify_string('aa', 'ab')
    assert_equal 4, numberify_string('ab', 'ab')
    assert_equal 5, numberify_string('ba', 'ab')
    assert_equal 6, numberify_string('bb', 'ab')

    assert_equal 0, numberify_string('', 'abc')
    assert_equal 1, numberify_string('a', 'abc')
    assert_equal 2, numberify_string('b', 'abc')
    assert_equal 3, numberify_string('c', 'abc')
    assert_equal 4, numberify_string('aa', 'abc')
    assert_equal 5, numberify_string('ab', 'abc')
  end

  def test_numberify_string_inv_function
    assert_raise(ArgumentError) { stringify_number(-1, 'ab') }
    assert_equal '', stringify_number(0, 'ab')
    assert_equal 'a', stringify_number(1, 'ab')
    assert_equal 'b', stringify_number(2, 'ab')
    assert_equal 'aa', stringify_number(3, 'ab')
    assert_equal 'ab', stringify_number(4, 'ab')
    assert_equal 'ba', stringify_number(5, 'ab')
    assert_equal 'bb', stringify_number(6, 'ab')

    assert_raise(ArgumentError) { stringify_number(-1, 'abc') }
    assert_equal '', stringify_number(0, 'abc')
    assert_equal 'a', stringify_number(1, 'abc')
    assert_equal 'b', stringify_number(2, 'abc')
    assert_equal 'c', stringify_number(3, 'abc')
    assert_equal 'aa', stringify_number(4, 'abc')
    assert_equal 'ab', stringify_number(5, 'abc')
  end
end
