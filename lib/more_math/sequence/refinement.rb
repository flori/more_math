# Refinement module that adds sequence conversion capabilities to Object.
#
# This refinement extends the Object class with a +to_seq+ method that
# converts any enumerable object into a MoreMath::Sequence.
#
# @example Converting an array to a sequence
#   using MoreMath::Sequence::Refinement
#   [1, 2, 3, 4, 5].to_seq
#   # => #<MoreMath::Sequence:0x00007f8b8c0b8a00>
#
# @example Converting other enumerables
#   using MoreMath::Sequence::Refinement
#   (1..5).to_seq
#   # => #<MoreMath::Sequence:0x00007f8b8c0b8a00>
#
# @note This refinement must be activated with +using
#   MoreMath::Sequence::Refinement+ before it can be used
# @note The resulting sequence is frozen and cannot be modified
module MoreMath::Sequence::Refinement
  refine ::Object do
    # Converts this object into a MoreMath::Sequence.
    #
    # This method iterates over the object (assuming it's enumerable) and
    # creates a new Sequence instance containing all elements.
    #
    # @return [MoreMath::Sequence] A new sequence containing all elements
    # @note This method works with any enumerable object
    # @note The resulting sequence is frozen and cannot be modified
    def to_seq
      ary = []
      each { |x| ary << x }
      MoreMath::Sequence.new(ary)
    end
  end
end
