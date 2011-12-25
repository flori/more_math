#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class StringNumeralTest < Test::Unit::TestCase
  include MoreMath

  def test_equality
    s = StringNumeral.from('abc')
    t = 731.to_string_numeral
    u = StringNumeral(:abc)
    assert_equal t, s
    assert_equal 'abc', s
    assert_equal u, t
    assert_equal s, u
    assert_equal s.hash, t.hash
  end

  def test_displaying
    s = StringNumeral.from('abc')
    assert_equal 'abc', s.string
    assert_equal 'abc', s.to_s
    assert_equal 'abc', s.to_str
    assert_equal 731, s.to_i
    assert_equal 731, s.to_int
    assert_equal '#<MoreMath::StringNumeral: "abc" 731>', s.inspect
  end

  def test_succ
    s = StringNumeral.from('abc', 'abc')
    t = s.succ
    assert_equal 'aca', t.string
    s.succ!
    assert_equal 'aca', s.string
  end

  def test_pred
    s = StringNumeral.from('aca', 'abc')
    t = s.pred
    assert_equal 'abc', t.string
    s.pred!
    assert_equal 'abc', s.string
  end

  def test_arithmetics
    s = StringNumeral.from('abc', 'abc')
    assert_equal 54, 3 * s
    assert_equal 54, s * 3
    assert_equal 6, s / 3
    assert_equal 3, 54 / s
    assert_equal 19, s + 1
    assert_equal 19, 1 + s
    assert_equal 17, s - 1
    assert_equal 1, 19 - s
    assert_equal 324, s ** 2
    assert_equal 0, s % 2
    assert_equal 9, s >> 1
    assert_equal 36, s << 1
    assert_equal 2, s ^ 16
    assert_equal 19, s | 1
    assert_equal 2, s & 2
    assert_equal 1, s[1]
  end
end
