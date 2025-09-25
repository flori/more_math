require 'more_math/ranking_common'

module MoreMath
  # A subset represents a selection of elements from a set, where each element
  # can either be included (1) or excluded (0) from the subset. Subsets are
  # ranked in lexicographic order, allowing efficient enumeration and indexing.
  #
  # @example Create a subset of size 3
  #   subset = Subset.new(3)
  #   # => #<Subset:0x6ae34 @last=7, @rank=0, @size=3>
  #
  # @example Create a subset with specific rank
  #   subset = Subset.new(3, 5)
  #   # => #<Subset:0x6ae34 @last=7, @rank=5, @size=3>
  #
  # @example Get the subset as an array of indices
  #   subset = Subset.new(3, 5)
  #   subset.value
  #   # => [0, 2]
  #
  # @example Project onto actual data
  #   subset = Subset.new(3, 5)
  #   subset.project(['a', 'b', 'c'])
  #   # => ['a', 'c']
  class Subset
    include Enumerable
    include RankingCommon

    # Returns a Subset instance for a collection of size +size+ with the rank
    # +rank+.
    # Creates a new Subset instance of <code>size</code> (and ranked with
    # <code>rank</code>).
    #
    # @param size [Integer] The size of the subset
    # @param rank [Integer] The rank of the subset (default: 0)
    def initialize(size, rank = 0)
      @size, self.rank = size, rank
      @last = (1 << size) - 1
    end

    # Creates a new Subset instance for a collection of size +size+ with the
    # rank +rank+.
    #
    # @param collection [Object] collection to use for projection
    # @param rank [Integer] the rank of this subset (default: 0)
    # @return [Subset] new subset instance
    def self.for(collection, rank = 0)
      subset = new(collection.size, rank)
      subset.instance_variable_set(:@collection, collection)
      subset
    end

    # Returns the power set of the collection +collection+.
    #
    # @param collection [Object] the collection to generate power set for
    # @return [Array<Array>] array of all possible subsets
    def self.power_set(collection)
      self.for(collection).map(&:value)
    end

    # Assigns <code>m</code> to the rank attribute of this Subset instance.
    # That implies that the indices produced by a call to the Subset#value method
    # of this instance is the subset ranked with this new <code>rank</code>.
    #
    # @param m [Integer] new rank value
    # @return [Integer] assigned rank
    def rank=(m)
      @rank = m % (1 << size)
    end

    # Returns the subset for rank #rank and #collection. (If no collection was
    # set it applies to the array [ 0, 1, ..., size - 1 ] instead.)
    #
    # @return [Array<Integer>] array of indices representing this subset
    def value
      result = []
      c = @collection || (0...size).to_a
      r = @rank
      size.times do |i|
        r[i] == 1 and result << c[i]
      end
      result
    end

    # This method maps elements from a given dataset based on the subset's
    # indices determined by its rank and returns the result, while
    # ensuring the input data size matches the subset's size.
    #
    # @param data [Object] data to project onto (optional)
    # @return [Array] projected result
    def project(data = nil)
      data ||= @collection || (0...size).to_a
      raise ArgumentError, "data size is != #{size}!" if data.size != size
      value.map { |i| data[i] }
    end
  end
end
