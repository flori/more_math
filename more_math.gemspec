# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{more_math}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = %q{2011-07-17}
  s.description = %q{Library that provides more mathematical functions/algorithms than standard Ruby.}
  s.email = %q{flori@ping.de}
  s.extra_rdoc_files = ["README.rdoc", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/version.rb", "lib/more_math/functions.rb", "lib/more_math/sequence.rb", "lib/more_math/linear_regression.rb", "lib/more_math/histogram.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/numerate_string_function.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/continued_fraction.rb", "lib/more_math.rb"]
  s.files = [".gitignore", "CHANGES", "Gemfile", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "install.rb", "lib/more_math.rb", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/continued_fraction.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/functions.rb", "lib/more_math/histogram.rb", "lib/more_math/linear_regression.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/numerate_string_function.rb", "lib/more_math/sequence.rb", "lib/more_math/version.rb", "more_math.gemspec", "tests/test_analysis.rb", "tests/test_cantor_pairing_function.rb", "tests/test_continued_fraction.rb", "tests/test_distribution.rb", "tests/test_functions.rb", "tests/test_histogram.rb", "tests/test_newton_bisection.rb", "tests/test_numerate_string_function.rb"]
  s.homepage = %q{http://flori.github.com/more_math}
  s.rdoc_options = ["--title", "MoreMath -- More Math in Ruby", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Library that provides more mathematics.}
  s.test_files = ["tests/test_cantor_pairing_function.rb", "tests/test_continued_fraction.rb", "tests/test_newton_bisection.rb", "tests/test_analysis.rb", "tests/test_functions.rb", "tests/test_numerate_string_function.rb", "tests/test_distribution.rb", "tests/test_histogram.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.0.4"])
      s.add_runtime_dependency(%q<spruz>, ["~> 0.2"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.0.4"])
      s.add_dependency(%q<spruz>, ["~> 0.2"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.0.4"])
    s.add_dependency(%q<spruz>, ["~> 0.2"])
  end
end
