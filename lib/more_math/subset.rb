require 'more_math/ranking_common'

module MoreMath
  class Subset
    include Enumerable
    include RankingCommon

    # Returns a Subset instance for a collection of size +size+ with the rank
    # +rank+.
    def initialize(size, rank = 0)
      @size, self.rank = size, rank
      @last = (1 << size) - 1
    end

    # Returns the subset of the collection +collection+ for the rank +rank+.
    def self.for(collection, rank = 0)
      subset = new(collection.size, rank)
      subset.instance_variable_set(:@collection, collection)
      subset
    end

    # Returns the power set of the collection +collection+.
    def self.power_set(collection)
      self.for(collection).map(&:value)
    end

    # Assigns <code>m</code> to the rank attribute of this object.
    def rank=(m)
      @rank = m % (1 << size)
    end

    # Returns the subset for rank #rank and #collection. (If no collection was
    # set it applies to the array [ 0, 1, ..., size - 1 ] instead.)
    def value
      result = []
      c = @collection || (0...size).to_a
      r = @rank
      0.upto(size) do |i|
        r[i] == 1 and result << c[i]
      end
      result
    end

    # This method maps elements from a given dataset based on the
    # subset's indices determined by its rank and returns the result, while
    # ensuring the input data size matches the subset's size.
    def project(data = nil)
      data ||= @collection || (0...size).to_a
      raise ArgumentError, "data size is != #{size}!" if data.size != size
      value.map { |i| data[i] }
    end
  end
end
