# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{more_math}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Florian Frank}]
  s.date = %q{2011-07-16}
  s.description = %q{Library that provides more mathematical functions/algorithms than standard Ruby.}
  s.email = %q{flori@ping.de}
  s.extra_rdoc_files = [%q{README.rdoc}, %q{lib/more_math/cantor_pairing_function.rb}, %q{lib/more_math/version.rb}, %q{lib/more_math/functions.rb}, %q{lib/more_math/sequence.rb}, %q{lib/more_math/linear_regression.rb}, %q{lib/more_math/string_numeral.rb}, %q{lib/more_math/histogram.rb}, %q{lib/more_math/constants/functions_constants.rb}, %q{lib/more_math/numberify_string_function.rb}, %q{lib/more_math/distributions.rb}, %q{lib/more_math/exceptions.rb}, %q{lib/more_math/newton_bisection.rb}, %q{lib/more_math/continued_fraction.rb}, %q{lib/more_math.rb}]
  s.files = [%q{.gitignore}, %q{.travis.yml}, %q{CHANGES}, %q{Gemfile}, %q{LICENSE}, %q{README.rdoc}, %q{Rakefile}, %q{VERSION}, %q{lib/more_math.rb}, %q{lib/more_math/cantor_pairing_function.rb}, %q{lib/more_math/constants/functions_constants.rb}, %q{lib/more_math/continued_fraction.rb}, %q{lib/more_math/distributions.rb}, %q{lib/more_math/exceptions.rb}, %q{lib/more_math/functions.rb}, %q{lib/more_math/histogram.rb}, %q{lib/more_math/linear_regression.rb}, %q{lib/more_math/newton_bisection.rb}, %q{lib/more_math/numberify_string_function.rb}, %q{lib/more_math/sequence.rb}, %q{lib/more_math/string_numeral.rb}, %q{lib/more_math/version.rb}, %q{more_math.gemspec}, %q{tests/test_analysis.rb}, %q{tests/test_cantor_pairing_function.rb}, %q{tests/test_continued_fraction.rb}, %q{tests/test_distribution.rb}, %q{tests/test_functions.rb}, %q{tests/test_histogram.rb}, %q{tests/test_newton_bisection.rb}, %q{tests/test_numberify_string_function.rb}]
  s.homepage = %q{http://flori.github.com/more_math}
  s.rdoc_options = [%q{--title}, %q{MoreMath -- More Math in Ruby}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5.1}
  s.summary = %q{Library that provides more mathematics.}
  s.test_files = [%q{tests/test_cantor_pairing_function.rb}, %q{tests/test_continued_fraction.rb}, %q{tests/test_newton_bisection.rb}, %q{tests/test_analysis.rb}, %q{tests/test_functions.rb}, %q{tests/test_distribution.rb}, %q{tests/test_histogram.rb}, %q{tests/test_numberify_string_function.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.0.5"])
      s.add_runtime_dependency(%q<spruz>, ["~> 0.2"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.0.5"])
      s.add_dependency(%q<spruz>, ["~> 0.2"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.0.5"])
    s.add_dependency(%q<spruz>, ["~> 0.2"])
  end
end
