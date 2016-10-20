module MoreMath
  module Entropy
    def entropy(text)
      chars = text.chars
      size  = chars.size

      chars.each_with_object(Hash.new(0.0)) { |c, h| h[c] += 1 }.
        each_value.reduce(0.0) do |entropy, count|
          frequency = count / size
          entropy + frequency * Math.log2(frequency)
        end.abs
    end

    def entropy_ideal(size)
      size <= 1 and return 0.0
      frequency = 1.0 / size
      -1.0 * size * frequency * Math.log2(frequency)
    end

    def entropy_percentage(text)
      size = text.each_char.size
      size <= 1 and return 0.0
      entropy(text) / entropy_ideal(size)
    end
  end
end
