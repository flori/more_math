module MoreMath
  # Common functionality for ranking systems. This module provides basic
  # ranking operations that are shared across different ranking implementations
  # in the MoreMath library, including permutations and subsets.
  module RankingCommon
    # Returns the size of this instance's collection, a Fixnum.
    #
    # @return [Integer] the size of the collection
    attr_reader :size

    # Returns the rank of this instance, a Fixnum in the range
    # of 0 and #last.
    #
    # @return [Integer] the current rank
    attr_reader :rank

    # Returns the rank of the last ranked instance.
    #
    # @return [Integer] the maximum rank value for this size
    attr_reader :last

    # Returns the collection the #rank applies to if any was set, otherwise
    # returns nil.
    #
    # @return [Object, nil] the associated collection or nil
    attr_reader :collection

    # Switches this instance to the next ranked instance. If this was the #last
    # instance it wraps around to the first (<code>rank == 0</code>) instance.
    #
    # @return [self] returns self after incrementing rank
    def next!
      self.rank += 1
      self
    end

    alias succ! next!

    # Returns the next ranked instance. If this instance is the #last instance
    # it returns the first (<code>rank == 0</code>) instance again.
    #
    # @return [self] a new instance with incremented rank
    def next
      clone.next!
    end

    alias succ next

    # Switches this instance to the previously ranked instance. If this was the
    # first instance it returns the last (<code>rank == #last</code>) instance.
    #
    # @return [self] returns self after decrementing rank
    def pred!
      self.rank -= 1
      self
    end

    # Returns the previously ranked instance. If this was the first instance it
    # returns the last (<code>rank == #last</code>) instance.
    #
    # @return [self] a new instance with decremented rank
    def pred
      clone.pred!
    end

    # Switches this instance to a randomly ranked instance.
    #
    # @return [self] returns self after setting random rank
    def random!
      new_rank = rand(last + 1).to_i
      self.rank = new_rank
      self
    end

    # Returns a randomly ranked instance.
    #
    # @return [self] a new instance with random rank
    def random
      clone.random!
    end

    # Iterates over all instances starting with the
    # first (<code>rank == 0</code>) ranked instance and ending with the
    # last (<code>rank == #last</code>) ranked instance while
    # yielding to a freshly created instance for every iteration
    # step.
    #
    # The mixed in methods from the Enumerable module rely on this method.
    #
    # @yield [instance] yields each instance in sequence
    # @return [self] returns self after iteration
    def each
      0.upto(last) do |r|
        klon = clone
        klon.rank = r
        yield klon
      end
      self
    end

    # Does something similar to #each. It doesn't create new instances (less
    # overhead) for every iteration step, but yields to a modified self
    # instead. This is useful if one only wants to call a method on the yielded
    # value and work with the result of this call. It's not a good idea to put
    # the yielded values in a data structure because all of them will reference
    # the same (this!) instance. If you want to do this use #each.
    #
    # @yield [instance] yields the current instance
    # @return [self] returns self after iteration
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
