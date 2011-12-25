require 'more_math'

module MoreMath
  class StringNumeral
    include ::MoreMath::NumberifyStringFunction

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

    def self.from_string(string, alphabet)
      new string, nil, alphabet
    end

    def self.from_number(number, alphabet)
      new nil, number, alphabet
    end

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

    def number
      @number ||= numberify_string(@string, @alphabet)
    end
    alias to_i number
    alias to_int number

    def string
      @string ||= stringify_number(@number, @alphabet).freeze
    end
    alias to_s string
    alias to_str string

    def inspect
      "#<#{self.class}: #{string.inspect} #{number.inspect}>"
    end

    attr_reader :alphabet

    def coerce(other)
      [ naturalize(other), number ]
    end

    def *(other)
      self.class.from_number(number * naturalize(other), @alphabet)
    end

    def +(other)
      self.class.from_number(number + naturalize(other), @alphabet)
    end

    def -(other)
      self.class.from_number(naturalize(number - other), @alphabet)
    end

    def /(other)
      self.class.from_number((number / naturalize(other)), @alphabet)
    end

    def %(other)
      self.class.from_number((number % naturalize(other)), @alphabet)
    end

    def **(other)
      self.class.from_number(number ** naturalize(other), @alphabet)
    end

    def <<(other)
      self.class.from_number(number << naturalize(other), @alphabet)
    end

    def >>(other)
      self.class.from_number(number >> naturalize(other), @alphabet)
    end

    def ^(other)
      self.class.from_number(number ^ naturalize(other), @alphabet)
    end

    def &(other)
      self.class.from_number(number & naturalize(other), @alphabet)
    end

    def |(other)
      self.class.from_number(number | naturalize(other), @alphabet)
    end

    def [](other)
      self.class.from_number(number[other.to_i], @alphabet)
    end

    def succ
      self.class.from_number(number + 1, @alphabet)
    end

    def succ!
      @number += 1
      @string = nil
      self
    end

    def pred
      self.class.from_number(naturalize(number - 1), @alphabet)
    end

    def pred!
      @number = naturalize(@number - 1)
      @string = nil
      self
    end

    def eql?(other)
      if other.respond_to?(:to_int)
        to_int == other.to_int
      elsif other.respond_to?(:to_str)
        to_str == other.to_str
      end
    end

    alias == eql?

    def hash
      number.hash
    end

    private

    def naturalize(number)
      number = number.to_i
      number < 0 ? 0 : number
    end

    module Functions
      def StringNumeral(other, alphabet = 'a'..'z')
        ::MoreMath::StringNumeral.from(other, alphabet)
      end

      def to_string_numeral(alphabet = 'a'..'z')
        StringNumeral(self, alphabet)
      end
    end
  end

  class ::Object
    include StringNumeral::Functions
  end
end
