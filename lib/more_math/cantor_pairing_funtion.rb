require 'more_math'

module MoreMath
  module CantorPairingFunction

    module_function
  
    def cantor_pairing(*xs)
      if xs.size == 1 and xs.first.respond_to?(:to_ary)
        xs = xs.first.to_ary
      end
      case xs.size
      when 0, 1
        raise ArgumentError, "at least two arguments are required"
      when 2
        x, y, = *xs
        (x + y) * (x + y + 1) / 2 + y
      else
        cantor_pairing(cantor_pairing(*xs[0..1]), *xs[2..-1])
      end
    end

    def self.cantor_pairing_inv_f(z)
      z * (z + 1) / 2
    end

    def self.cantor_pairing_inv_q(z)
      v = 0
      while cantor_pairing_inv_f(v) <= z
        v += 1
      end
      v - 1
    end
   
    def cantor_pairing_inv(c, n = 2)
      raise ArgumentError, "n is required to be >= 2" unless n >= 2
      result = []
      begin
        q = CantorPairingFunction.cantor_pairing_inv_q(c)
        y = c - CantorPairingFunction.cantor_pairing_inv_f(q)
        x = q - y
        result.unshift y
        c = x
        n -= 1
      end until n <= 1
      result.unshift x
    end
  end
end
