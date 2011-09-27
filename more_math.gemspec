# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "more_math"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = "2011-09-27"
  s.description = "Library that provides more mathematical functions/algorithms than standard Ruby."
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.rdoc", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/continued_fraction.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/functions.rb", "lib/more_math/histogram.rb", "lib/more_math/linear_regression.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/numberify_string_function.rb", "lib/more_math/power_set.rb", "lib/more_math/sequence.rb", "lib/more_math/string_numeral.rb", "lib/more_math/version.rb", "lib/more_math.rb"]
  s.files = [".gitignore", ".travis.yml", "CHANGES", "Gemfile", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "lib/more_math.rb", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/continued_fraction.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/functions.rb", "lib/more_math/histogram.rb", "lib/more_math/linear_regression.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/numberify_string_function.rb", "lib/more_math/power_set.rb", "lib/more_math/sequence.rb", "lib/more_math/string_numeral.rb", "lib/more_math/version.rb", "more_math.gemspec", "tests/test_cantor_pairing_function.rb", "tests/test_continued_fraction.rb", "tests/test_distribution.rb", "tests/test_functions.rb", "tests/test_histogram.rb", "tests/test_newton_bisection.rb", "tests/test_numberify_string_function.rb", "tests/test_power_set.rb", "tests/test_sequence.rb"]
  s.homepage = "http://flori.github.com/more_math"
  s.rdoc_options = ["--title", "MoreMath -- More Math in Ruby", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Library that provides more mathematics."
  s.test_files = ["tests/test_cantor_pairing_function.rb", "tests/test_continued_fraction.rb", "tests/test_distribution.rb", "tests/test_functions.rb", "tests/test_histogram.rb", "tests/test_newton_bisection.rb", "tests/test_numberify_string_function.rb", "tests/test_power_set.rb", "tests/test_sequence.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<tins>, ["~> 0.3"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.1.0"])
      s.add_dependency(%q<tins>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.1.0"])
    s.add_dependency(%q<tins>, ["~> 0.3"])
  end
end
