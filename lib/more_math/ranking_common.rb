module MoreMath
  module RankingCommon
    # Returns the size of this permutation, a Fixnum.
    attr_reader :size

    # Returns the size of this permutation, a Fixnum in the range
    # of 0 and Permutation#last.
    attr_reader :rank

    # Returns the rank of the last ranked Permutation of size
    # Permutation#size .
    attr_reader :last

    # Switches this instance to the next ranked Permutation.
    # If this was the Permutation#last permutation it wraps around
    # the first (<code>rank == 0</code>) permutation.
    def next!
      self.rank += 1
      self
    end

    alias succ! next!

    # Returns the next ranked Permutation instance.
    # If this instance is the Permutation#last permutation it returns the first
    # (<code>rank == 0</code>) permutation.
    def next
      clone.next!
    end

    alias succ next

    # Switches this instance to the previously ranked Permutation.
    # If this was the first permutation it returns the last (<code>rank ==
    # Permutation#last</code>) permutation.
    def pred!
      self.rank -= 1
      self
    end

    # Returns the previously ranked Permutation. If this was the first
    # permutation it returns the last (<code>rank == Permutation#last</code>)
    # permutation.
    def pred
      clone.pred!
    end

    # Switches this Permutation instance to random permutation
    # of size Permutation#size.
    def random!
      new_rank = rand(last + 1).to_i
      self.rank = new_rank
      self
    end

    # Returns a random Permutation instance # of size Permutation#size.
    def random
      clone.random!
    end

    # Iterates over all permutations of size Permutation#size starting with the
    # first (<code>rank == 0</code>) ranked permutation and ending with the
    # last (<code>rank == Permutation#last</code>) ranked permutation while
    # yielding to a freshly created Permutation instance for every iteration
    # step.
    #
    # The mixed in methods from the Enumerable module rely on this method.
    def each # :yields: perm
      0.upto(last) do |r|
        klon = clone
        klon.rank = r
        yield klon
      end
      self
    end

    # Does something similar to Permutation#each. It doesn't create new
    # instances (less overhead) for every iteration step, but yields to a
    # modified self instead. This is useful if one only wants to call a
    # method on the yielded value and work with the result of this call. It's
    # not a good idea to put the yielded values in a data structure because the
    # will all reference the same (this!) instance. If you want to do this
    # use Permutation#each.
    def each!
      old_rank = rank
      0.upto(last) do |r|
        self.rank = r
        yield self
      end
      self
    ensure
      self.rank = old_rank
    end
  end
end
