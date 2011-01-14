require 'more_math'

module MoreMath
  module NumerateStringFunction
    Functions = MoreMath::Functions

    module_function

    def numerate_string(string, alphabet = 'a'..'z')
      alphabet = NumerateStringFunction.convert_alphabet alphabet
      s, k = string.size, alphabet.size
      result = 0
      for i in 0...s
        c = string[i, 1]
        a = (alphabet.index(c) || raise(ArgumentError, "#{c.inspect} not in alphabet")) + 1
        j = s - i - 1
        result += a * k ** j
      end
      result
    end

    def numerate_string_inv(number, alphabet = 'a'..'z')
      case
      when number < 0
        raise ArgumentError, "number is required to be >= 0"
      when number == 0
        return ''
      end
      alphabet = NumerateStringFunction.convert_alphabet alphabet
      s = Functions.log_floor(number + 1, alphabet.size)
      k, m = alphabet.size, number
      result = ' ' * s
      q = m
      (s - 1).downto(0) do |i|
        r = q / k
        q = r * k < q ? r : r - 1
        result[i] = alphabet[m - q * k - 1]
        m = q
      end
      result
    end

    def self.convert_alphabet(alphabet)
      if alphabet.respond_to?(:to_ary)
        alphabet.to_ary
      elsif alphabet.respond_to?(:to_str)
        alphabet.to_str.split(//)
      else
        alphabet.to_a
      end
    end

  end
end
