require 'more_math/ranking_common'

module MoreMath
  class Subset
    include Enumerable
    include RankingCommon

    def initialize(size, rank)
      @size, self.rank = size, rank
      @last = (1 << size) - 1
    end

    def self.for(collection, rank = 0)
      subset = new(collection.size, rank)
      subset.instance_variable_set(:@collection, collection)
      subset
    end

    # Assigns <code>m</code> to the rank attribute of this object.
    def rank=(m)
      @rank = m % (1 << size)
    end

    def value
      result = []
      c = @collection || (1..size).to_a
      r = @rank
      0.upto(size) do |i|
        r[i] == 1 and result << c[i]
      end
      result
    end
  end
end
