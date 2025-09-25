module MoreMath
  # StringNumeral provides a way to treat strings as numbers using a base-N
  # system where N is the size of the alphabet. This allows for arithmetic
  # operations on strings, converting them to numeric representations and back.
  #
  # The implementation uses the Cantor pairing function approach for encoding
  # strings into integers and vice versa, making it suitable for applications
  # requiring ordered string enumeration or Gödel numbering.
  #
  # @example Basic usage
  #   include MoreMath
  #
  #   # Convert a string to its numeric representation
  #   str_num = "abc".to_string_numeral
  #   puts str_num.number  # => 731  (assuming 'a'..'z' alphabet)
  #
  #   # Convert back to string
  #   puts 731.to_string_numeral.string  # => "abc"
  #
  # @example Arithmetic operations
  #   a = "hello".to_string_numeral
  #   b = "world".to_string_numeral
  #
  #   # Addition
  #   sum = a + b
  #   puts sum.string  # => "hello" + "world" (in numeric sense)
  #
  # @example With custom alphabet
  #   custom_alphabet = ['a', 'b', 'c']
  #   str_num = StringNumeral.from("abc", custom_alphabet)
  #   puts str_num.number  # => 18 (base-3 representation)
  class StringNumeral
    include ::MoreMath::NumberifyStringFunction

    # Creates a StringNumeral instance from an object.
    #
    # This is the primary factory method that handles conversion from various
    # input types:
    # - Symbol: converts to string first
    # - String: uses directly as string representation
    # - Integer: converts to numeric representation
    # - Other objects: calls to_str or to_int as appropriate
    #
    # @param object [Object] The input object to convert
    # @param alphabet [Array<String>, Range<String>] The alphabet to use for conversion
    # @return [StringNumeral] A new StringNumeral instance
    def self.from(object, alphabet = 'a'..'z')
      if Symbol === object
        StringNumeral.from_string(object.to_s, alphabet)
      elsif object.respond_to?(:to_str)
        StringNumeral.from_string(object.to_str, alphabet)
      elsif object.respond_to?(:to_int)
        StringNumeral.from_number(object.to_int, alphabet)
      else
        StringNumeral.from_string(object.to_s, alphabet)
      end
    end

    # Creates a StringNumeral instance from a string.
    #
    # @param string [String] The string to convert
    # @param alphabet [Array<String>, Range<String>] The alphabet to use
    # @return [StringNumeral] A new StringNumeral instance
    def self.from_string(string, alphabet)
      new string, nil, alphabet
    end

    # Creates a StringNumeral instance from a number.
    #
    # @param number [Integer] The number to convert
    # @param alphabet [Array<String>, Range<String>] The alphabet to use
    # @return [StringNumeral] A new StringNumeral instance
    def self.from_number(number, alphabet)
      new nil, number, alphabet
    end

    # Initializes a StringNumeral instance.
    #
    # This private constructor handles the internal state setup for either
    # string-to-number or number-to-string conversion.
    #
    # @param string [String, nil] The string representation (if converting from string)
    # @param number [Integer, nil] The numeric representation (if converting from number)
    # @param alphabet [Array<String>, Range<String>] The alphabet to use
    # @raise [ArgumentError] If the string contains characters not in the alphabet
    def initialize(string, number, alphabet)
      @alphabet = NumberifyStringFunction.convert_alphabet(alphabet).freeze
      if string
        @string = string.to_s
        string.each_char.each do |c|
          @alphabet.include?(c) or raise ArgumentError,
            "illegal character #{c.inspect} in #{@string.inspect} for alphabet #{@alphabet.inspect}"
        end
      elsif number
        @number = number.to_i
      end
    end
    private_class_method :new

    # Returns the numeric representation of this StringNumeral.
    #
    # This method converts the internal string representation to its numeric value
    # using the specified alphabet. The conversion follows a positional numeral system
    # where each character position represents a power of the alphabet size.
    #
    # @return [Integer] The numeric representation
    def number
      @number ||= numberify_string(@string, @alphabet)
    end
    alias to_i number
    alias to_int number

    # Returns the string representation of this StringNumeral.
    #
    # This method converts the internal numeric representation back to its string form
    # using the specified alphabet. It's the inverse operation of {#number}.
    #
    # @return [String] The string representation
    def string
      @string ||= stringify_number(@number, @alphabet).freeze
    end
    alias to_s string
    alias to_str string

    # Returns a string representation for debugging.
    #
    # @return [String] A debug-friendly representation of this instance
    def inspect
      "#<#{self.class}: #{string.inspect} #{number.inspect}>"
    end

    # Returns the alphabet used by this StringNumeral.
    #
    # @return [Array<String>] The alphabet array
    attr_reader :alphabet

    # Converts another object to a numeric value for arithmetic operations.
    #
    # This method is used in Ruby's coercion protocol to enable mixed-type arithmetic.
    #
    # @param other [Object] The other operand
    # @return [Array<Integer>] Array containing the naturalized values
    def coerce(other)
      [ naturalize(other), number ]
    end

    # Performs addition with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The value to add
    # @return [StringNumeral] A new StringNumeral instance representing the sum
    def +(other)
      self.class.from_number(number + naturalize(other), @alphabet)
    end

    # Performs multiplication with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The value to multiply by
    # @return [StringNumeral] A new StringNumeral instance representing the product
    def *(other)
      self.class.from_number(number * naturalize(other), @alphabet)
    end

    # Performs subtraction with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The value to subtract
    # @return [StringNumeral] A new StringNumeral instance representing the difference
    def -(other)
      self.class.from_number(naturalize(number - other), @alphabet)
    end

    # Performs division with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The divisor
    # @return [StringNumeral] A new StringNumeral instance representing the quotient
    def /(other)
      self.class.from_number((number / naturalize(other)), @alphabet)
    end

    # Performs modulo operation with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The divisor for modulo
    # @return [StringNumeral] A new StringNumeral instance representing the remainder
    def %(other)
      self.class.from_number((number % naturalize(other)), @alphabet)
    end

    # Performs exponentiation with another StringNumeral or numeric value.
    #
    # @param other [StringNumeral, Integer] The exponent
    # @return [StringNumeral] A new StringNumeral instance representing the power
    def **(other)
      self.class.from_number(number ** naturalize(other), @alphabet)
    end

    # Performs left bit shift with another numeric value.
    #
    # @param other [Integer] The number of bits to shift
    # @return [StringNumeral] A new StringNumeral instance representing the shifted value
    def <<(other)
      self.class.from_number(number << naturalize(other), @alphabet)
    end

    # Performs right bit shift with another numeric value.
    #
    # @param other [Integer] The number of bits to shift
    # @return [StringNumeral] A new StringNumeral instance representing the shifted value
    def >>(other)
      self.class.from_number(number >> naturalize(other), @alphabet)
    end

    # Performs bitwise XOR with another numeric value.
    #
    # @param other [Integer] The value to XOR with
    # @return [StringNumeral] A new StringNumeral instance representing the result
    def ^(other)
      self.class.from_number(number ^ naturalize(other), @alphabet)
    end

    # Performs bitwise AND with another numeric value.
    #
    # @param other [Integer] The value to AND with
    # @return [StringNumeral] A new StringNumeral instance representing the result
    def &(other)
      self.class.from_number(number & naturalize(other), @alphabet)
    end

    # Performs bitwise OR with another numeric value.
    #
    # @param other [Integer] The value to OR with
    # @return [StringNumeral] A new StringNumeral instance representing the result
    def |(other)
      self.class.from_number(number | naturalize(other), @alphabet)
    end

    # Performs indexing operation on the numeric value.
    #
    # @param other [Integer] The index to access
    # @return [StringNumeral] A new StringNumeral instance representing the indexed result
    def [](other)
      self.class.from_number(number[other.to_i], @alphabet)
    end

    # Returns the successor of this StringNumeral.
    #
    # @return [StringNumeral] A new StringNumeral with number incremented by 1
    def succ
      self.class.from_number(number + 1, @alphabet)
    end

    # Increments this StringNumeral in place.
    #
    # @return [self] Returns self after incrementing
    def succ!
      @number += 1
      @string = nil
      self
    end

    # Returns the predecessor of this StringNumeral.
    #
    # @return [StringNumeral] A new StringNumeral with number decremented by 1
    def pred
      self.class.from_number(naturalize(number - 1), @alphabet)
    end

    # Decrements this StringNumeral in place.
    #
    # @return [self] Returns self after decrementing
    def pred!
      @number = naturalize(@number - 1)
      @string = nil
      self
    end

    # Checks equality with another object.
    #
    # @param other [Object] The object to compare with
    # @return [Boolean] true if equal, false otherwise
    def eql?(other)
      if other.respond_to?(:to_int)
        to_int == other.to_int
      elsif other.respond_to?(:to_str)
        to_str == other.to_str
      end
    end

    alias == eql?

    # Returns a hash value for this StringNumeral.
    #
    # @return [Integer] The hash value
    def hash
      number.hash
    end

    private

    # Ensures a value is treated as a non-negative integer.
    #
    # @param number [Object] The number to normalize
    # @return [Integer] The normalized non-negative integer
    def naturalize(number)
      number = number.to_i
      number < 0 ? 0 : number
    end

    # Module containing convenience methods for StringNumeral conversion.
    module Functions
      # Creates a StringNumeral from an object.
      #
      # @param other [Object] The object to convert
      # @param alphabet [Array<String>, Range<String>] The alphabet to use
      # @return [StringNumeral] A new StringNumeral instance
      def StringNumeral(other, alphabet = 'a'..'z')
        ::MoreMath::StringNumeral.from(other, alphabet)
      end

      # Converts this object to a StringNumeral.
      #
      # @param alphabet [Array<String>, Range<String>] The alphabet to use
      # @return [StringNumeral] A new StringNumeral instance
      def to_string_numeral(alphabet = 'a'..'z')
        StringNumeral(self, alphabet)
      end
    end
  end

  # Extends the Object class with StringNumeral conversion methods.
  class ::Object
    include StringNumeral::Functions
  end
end
