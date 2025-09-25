require 'more_math/ranking_common'

module MoreMath
  # A permutation represents a rearrangement of elements in a set. Permutations
  # are ranked in lexicographic order, allowing efficient enumeration and
  # indexing.
  #
  # @example Create a permutation of size 3
  #   perm = Permutation.new(3)
  #   # => #<Permutation:0x6ae34 @last=5, @rank=0, @size=3>
  #
  # @example Create a permutation with specific rank
  #   perm = Permutation.new(3, 5)
  #   # => #<Permutation:0x6ae34 @last=5, @rank=5, @size=3>
  #
  # @example Get the permutation as an array of indices
  #   perm = Permutation.new(3, 5)
  #   perm.value
  #   # => [2, 1, 0]
  #
  # @example Project onto actual data
  #   perm = Permutation.new(3, 5)
  #   perm.project(['a', 'b', 'c'])
  #   # => ['c', 'b', 'a']
  class Permutation
    include Enumerable
    include Comparable
    include RankingCommon

    # Creates a new Permutation instance of <code>size</code> (and ranked with
    # <code>rank</code>). Creates a new Permutation instance of size (and
    # ranked with rank).
    #
    # @param size [Integer] The size of the permutation
    # @param rank [Integer] The rank of the permutation (default: 0)
    def initialize(size, rank = 0)
      @size, self.rank = size, rank
      @last = factorial(size) - 1
    end

    # Creates a new Permutation instance from the Array
    # <code>indices</code>, that should consist of a permutation of Fixnums
    # in the range of <code>0</code> and <code>indices.size - 1</code>. This is
    # for example the result of a call to the Permutation#value method.
    #
    # @param indices [Array<Integer>] array of indices representing a permutation
    # @return [Permutation] new permutation instance
    def self.from_value(indices)
      indices = indices.clone
      obj = new(indices.size)
      obj.instance_eval do
        self.rank = rank_indices(indices)
      end
      obj
    end

    # Creates a new Permutation instance from the Array of Arrays
    # <code>cycles</code>. This is for example the result of a
    # call to the Permutation#cycles method .
    #
    # @param cycles [Array<Array<Integer>>] array of cycles
    # @param max [Integer] maximum element index (default: 0)
    # @return [Permutation] new permutation instance
    def self.from_cycles(cycles, max = 0)
      indices = Array.new(max)
      cycles.each do |cycle|
        cycle.empty? and next
        for i in 0...cycle.size
          indices[ cycle[i - 1] ] = cycle[i]
        end
      end
      indices.each_with_index { |r, i| r or indices[i] = i }
      from_value(indices)
    end

    # A permutation instance of size collection.size is created with
    # collection as the default Permutation#project data object. A
    # collection should respond to size, [], and []=. The Permutation
    # instance will default to rank 0 if none is given.
    #
    # @param collection [Object] collection to use for projection
    # @param rank [Integer] the rank of this permutation (default: 0)
    # @return [Permutation] new permutation instance
    def self.for(collection, rank = 0)
      perm = new(collection.size, rank)
      perm.instance_variable_set(:@collection, collection)
      perm
    end

    # Shortcut to generate the identity permutation that has
    # Permutation#size <code>n</code>.
    #
    # @param n [Integer] size of identity permutation
    # @return [Permutation] identity permutation of size n
    def self.identity(n)
      new(n)
    end

    # Returns the identity permutation that has the same Permutation#size as this
    # instance.
    #
    # @return [Permutation] identity permutation of same size
    def identity
      self.class.new(size)
    end

    # Builds a permutation that maps <code>a</code> into <code>b</code>.
    # Both arguments must be the same length and must contain the same
    # elements.  If these arrays contain duplicate elements, the solution
    # will not be unique.
    #
    # @param a [Array] initial array of elements
    # @param b [Array] target array of elements
    # @return [Permutation] permutation that maps a to b
    def self.for_mapping(a, b)
      a.size == b.size or
        raise ArgumentError, "Initial and final lists must be the same length"

      lookup = Hash.new { |h, k| h[k] = [] }
      a.size.times { |i| lookup[a[i]] <<= i }

      value = Array.new(b.size) do |i|
        e = b[i]
        lookup[e].pop or raise ArgumentError, "no corresponding element for #{e.inspect}"
      end
      Permutation.from_value value
    end

    # Computes the nth power (ie the nth repeated permutation) of this instance.
    # Negative powers are taken to be powers of the inverse.
    #
    # @param n [Integer] power to raise permutation to
    # @return [Permutation] result of permutation raised to power n
    def power(n)
      if n.respond_to?(:to_int)
        n = n.to_int
      else
        raise TypeError, "#{n.inspect} cannot be converted to an integer"
      end
      if n >= 0
        (1..n).inject(identity) { |p, e| p * self }
      else # negative powers are taken to be powers of the inverse
        -power(-n)
      end
    end

    alias ** power

    # Assigns <code>m</code> to the rank attribute of this Permutation
    # instance. That implies that the indices produced by a call to the
    # Permutation#value method of this instance is the permutation ranked with
    # this new <code>rank</code>.
    #
    # @param m [Integer] new rank value
    # @return [Integer] assigned rank
    def rank=(m)
      @rank = m % factorial(size)
    end

    # Returns the indices in the range of 0  to Permutation#size - 1
    # of this permutation that is ranked with Permutation#rank.
    #
    # <b>Example:</b>
    #  perm = Permutation.new(6, 312)
    #  # => #<Permutation:0x6ae34 @last=719, @rank=312, @size=6>
    #  perm.value
    #  # => [2, 4, 0, 1, 3, 5]
    #
    # @return [Array<Integer>] array of indices representing this permutation
    def value
      unrank_indices(@rank)
    end

    # Returns the projection of this instance's Permutation#value
    # into the <code>data</code> object that should respond to
    # the #[] method. If this Permutation inbstance was created
    # with Permutation.for the collection used to create
    # it is used as a data object.
    #
    # @example
    #   perm = Permutation.new(6, 312)
    #   # => #<Permutation:0x6ae34 @last=719, @rank=312, @size=6>
    #   perm.project("abcdef")
    #   # => "ceabdf"
    #
    # @param data [Object] data to project onto (optional)
    # @return [Object] projected result
    def project(data = (@collection if defined? @collection))
      data or raise ArgumentError, "a collection is required to project"
      raise ArgumentError, "data size is != #{size}!" if data.size != size
      projection = data.dup
      value.each_with_index { |i, j| projection[j] = data[i] }
      projection
    end

    # Compare this permutation with another based on size and rank.
    #
    # This method implements the comparison operator for Permutation objects,
    # allowing them to be sorted and compared using standard Ruby comparison
    # operators. The comparison is first done by size, then by rank for permutations
    # of the same size.
    #
    # @param other [Object] the other permutation to compare with
    # @return [Integer] -1 if this permutation should be ordered before the other,
    #   0 if they are equal, 1 if this permutation should be ordered after the other
    def <=>(other)
      sc = size <=> other.size
      if sc.zero?
        rank <=> other.rank
      else
        sc
      end
    end

    # Returns true if this Permutation instance and the other have the same
    # value, that is both Permutation instances have the same Permutation#size
    # and the same Permutation#rank.
    #
    # @param other [Object] object to compare with
    # @return [Boolean] true if equal
    def eql?(other)
      self.class == other.class && size == other.size && rank == other.rank
    end

    alias == eql?

    # Computes a unique hash value for this Permutation instance.
    #
    # @return [Integer] hash value
    def hash
      size.hash ^ rank.hash
    end

    # Switches this Permutation instance to the inverted permutation.
    # (See Permutation#compose for an example.)
    #
    # @return [Permutation] self after inversion
    def invert!
      indices = unrank_indices(rank)
      inverted = Array.new(size)
      for i in 0...size
        inverted[indices[i]] = i
      end
      self.rank = rank_indices(inverted)
      self
    end

    # Returns the inverted Permutation of this Permutation instance.
    # (See Permutation#compose for an example.)
    #
    # @return [Permutation] inverted permutation
    def invert
      clone.invert!
    end

    alias -@ invert

    # Compose this Permutation instance and the other to
    # a new Permutation. Note that a permutation
    # composed with it's inverted permutation yields
    # the identity permutation, the permutation with rank 0.
    #
    # @example
    #   p1 = Permutation.new(5, 42)
    #   # => #<Permutation:0x75370 @last=119, @rank=42, @size=5>
    #   p2 = p1.invert
    #   # => #<Permutation:0x653d0 @last=119, @rank=51, @size=5>
    #   p1.compose(p2)
    #   => #<Permutation:0x639a4 @last=119, @rank=0, @size=5>
    #
    #   # Or a little nicer to look at:
    #   p1 * -p1
    #   # => #<Permutation:0x62004 @last=119, @rank=0, @size=5>
    #
    # @param other [Permutation] permutation to compose with
    # @return [Permutation] composed permutation
    def compose(other)
      size == other.size or raise ArgumentError,
        "permutations of unequal sizes cannot be composed!"
      indices = value
      composed = other.value.map { |i| indices[i] }
      klon = clone
      klon.rank = rank_indices(composed)
      klon
    end

    alias * compose

    # Returns the cycles representation of this Permutation instance.
    # The return value of this method can be used to create a
    # new Permutation instance with the Permutation.from_cycles method.
    #
    # @example
    #  perm = Permutation.new(7, 23)
    #  # => #<Permutation:0x58541c @last=5039, @rank=23, @size=7>
    #  perm.cycles
    #  # => [[3, 6], [4, 5]]
    #
    # @return [Array<Array<Integer>>] array of cycles
    def cycles
      perm = value
      result = [[]]
      seen = {}
      current = nil
      loop do
        current or current = perm.find { |x| !seen[x] }
        break unless current
        if seen[current]
          current = nil
          result << []
        else
          seen[current] = true
          result[-1] << current
          current = perm[current]
        end
      end
      result.pop
      result.select { |c| c.size > 1 }.map do |c|
        min_index = c.index(c.min)
        c[min_index..-1] + c[0...min_index]
      end
    end

    # Returns the signum of this Permutation instance.
    # It's -1 if this permutation is odd and 1 if it's
    # an even permutation.
    #
    # A permutation is odd if it can be represented by an odd number of
    # transpositions (cycles of length 2), or even if it can be represented of
    # an even number of transpositions.
    #
    # @return [Integer] 1 for even, -1 for odd
    def signum
      s = 1
      cycles.each do |c|
        c.size % 2 == 0 and s *= -1
      end
      s
    end

    alias sgn signum

    # Returns true if this permutation is even, false otherwise.
    #
    # @return [Boolean] true if even permutation
    def even?
      signum == 1
    end

    # Returns true if this permutation is odd, false otherwise.
    #
    # @return [Boolean] true if odd permutation
    def odd?
      signum == -1
    end

    private

    @@fcache = [ 1 ]

    # Computes the factorial of a number using memoization for efficiency. This
    # method is used internally by the permutation ranking system to calculate
    # the total number of permutations for a given size.
    #
    # @param n [Integer] the number to calculate factorial for
    # @return [Integer] the factorial of n
    def factorial(n)
      @@fcache.size.upto(n) { |i| @@fcache[i] =  i * @@fcache[i - 1] }
      @@fcache[n]
    end

    # Rank the indices of the permutation +p+. Beware that this method may
    # change its argument +p+. Rank the indices of the permutation p. Beware
    # that this method may change its argument p.
    #
    # @param p [Array<Integer>] the permutation indices to rank
    # @return [Integer] the rank of the permutation indices
    def rank_indices(p)
      result = 0
      for i in 0...size
        result += p[i] * factorial(size - i - 1)
        for j in (i + 1)...size
          p[j] -= 1 if p[j] > p[i]
        end
      end
      result
    end

    # Unranks the given index value into an array of permutation indices.
    #
    # This method converts a rank value back into its corresponding permutation
    # indices representation. It's the inverse operation of the rank_indices
    # method and is used internally by the permutation ranking system to
    # reconstruct permutation arrays from their rank values.
    #
    # @param m [Integer] The rank value to unrank
    # @return [Array<Integer>] Array of indices representing the permutation
    def unrank_indices(m)
      result = Array.new(size, 0)
      for i in 0...size
        f = factorial(i)
        x = m % (f * (i + 1))
        m -= x
        x /= f
        result[size - i - 1] = x
        x -= 1
        for j in (size - i)...size
          result[j] += 1 if result[j] > x
        end
      end
      result
    end
  end
end
