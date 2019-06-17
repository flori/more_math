#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

using MoreMath::Sequence::Refinement

class SequenceTest < Test::Unit::TestCase
  def test_refinement
    assert_kind_of MoreMath::Sequence, [1,2,3].to_seq
  end
end

