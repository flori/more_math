module MoreMath
  unless defined?(::MoreMath::Infinity) == 'constant'
    Infinity = 1.0 / 0      # Refers to floating point infinity.
  end

  Dir.chdir(File.join(File.dirname(__FILE__), 'more_math', '..')) do
    Dir['**/*.rb'].each do |filename|
      require filename.gsub(/\.rb\Z/, '')
    end
  end
end
