module MoreMath
  Infinity = 1.0 / 0      # Refers to floating point infinity.

  Dir.chdir(File.join(File.dirname(__FILE__), 'more_math')) do
    Dir['**/*.rb'].each do |filename|
      require File.join('more_math', filename.gsub(/\.rb\Z/, ''))
    end
  end
end
