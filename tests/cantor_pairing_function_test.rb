#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class CantorPairingFunctionTest < Test::Unit::TestCase
  include MoreMath::Functions

  def test_cantor_pairing_function
    assert_equal 69, cantor_pairing([ 1, 2, 3 ])
    assert_equal 69, cantor_pairing(1, 2, 3)
    assert_equal 172, cantor_pairing(3, 2, 1)
    assert_raise(ArgumentError) { cantor_pairing([ 1 ]) }
    assert_raise(ArgumentError) { cantor_pairing(1) }
  end

  def test_cantor_pairing_function_inv
    assert_equal [ 8, 3 ], cantor_pairing_inv(69)
    assert_equal [ 1, 2, 3 ], cantor_pairing_inv(69, 3)
    assert_equal [ 17, 1 ], cantor_pairing_inv(172)
    assert_equal [ 3, 2, 1 ], cantor_pairing_inv(172, 3)
  end
end
