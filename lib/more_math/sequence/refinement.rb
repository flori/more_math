module MoreMath::Sequence::Refinement
  refine ::Object do
    def to_seq
      ary = []
      each { |x| ary << x }
      MoreMath::Sequence.new(ary)
    end
  end
end
