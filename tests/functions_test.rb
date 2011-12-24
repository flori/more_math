#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class FunctionsTest < Test::Unit::TestCase
  include MoreMath::Functions

  def gammaP5_2(x)
    gammaP_regularized(x, 5 / 2.0)
  end

  def gammaQ5_2(x)
    gammaQ_regularized(x, 5 / 2.0)
  end

  X1 = [ 0.0, 0.1, 0.5, 0.9, 0.95, 0.995, 1.0, 2, 3, 5, 10, 100 ]

  Y1 = [ 0.0000000000, 0.0008861388, 0.0374342268, 0.1239315997, 0.1371982774,
    0.1494730091, 0.1508549639, 0.4505840486, 0.6937810816, 0.9247647539,
    0.9987502694, 1.0000000000 ]

  def test_gammaPQ
    assert gammaQ_regularized(1, -1).nan?
    assert gammaP_regularized(1, -1).nan?
    assert gammaP5_2(-1).nan?
    assert gammaQ5_2(-1).nan?
    X1.zip(Y1) do |x, y|
      assert_in_delta y, gammaP5_2(x), 1E-10
      assert_in_delta y, 1 - gammaQ5_2(x), 1E-10
    end
  end
end
