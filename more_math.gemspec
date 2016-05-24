# -*- encoding: utf-8 -*-
# stub: more_math 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "more_math"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florian Frank"]
  s.date = "2016-05-24"
  s.description = "Library that provides more mathematical functions/algorithms than standard Ruby."
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.rdoc", "lib/more_math.rb", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/continued_fraction.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/functions.rb", "lib/more_math/histogram.rb", "lib/more_math/linear_regression.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/numberify_string_function.rb", "lib/more_math/permutation.rb", "lib/more_math/ranking_common.rb", "lib/more_math/sequence.rb", "lib/more_math/sequence/moving_average.rb", "lib/more_math/sequence/refinement.rb", "lib/more_math/string_numeral.rb", "lib/more_math/subset.rb", "lib/more_math/version.rb"]
  s.files = [".codeclimate.yml", ".gitignore", ".rubocop.yml", ".travis.yml", "CHANGES", "Gemfile", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "lib/more_math.rb", "lib/more_math/cantor_pairing_function.rb", "lib/more_math/constants/functions_constants.rb", "lib/more_math/continued_fraction.rb", "lib/more_math/distributions.rb", "lib/more_math/exceptions.rb", "lib/more_math/functions.rb", "lib/more_math/histogram.rb", "lib/more_math/linear_regression.rb", "lib/more_math/newton_bisection.rb", "lib/more_math/numberify_string_function.rb", "lib/more_math/permutation.rb", "lib/more_math/ranking_common.rb", "lib/more_math/sequence.rb", "lib/more_math/sequence/moving_average.rb", "lib/more_math/sequence/refinement.rb", "lib/more_math/string_numeral.rb", "lib/more_math/subset.rb", "lib/more_math/version.rb", "more_math.gemspec", "tests/cantor_pairing_function_test.rb", "tests/continued_fraction_test.rb", "tests/distribution_test.rb", "tests/functions_test.rb", "tests/histogram_test.rb", "tests/newton_bisection_test.rb", "tests/numberify_string_function_test.rb", "tests/permutation_test.rb", "tests/sequence_moving_average_test.rb", "tests/sequence_test.rb", "tests/string_numeral_test.rb", "tests/subset_test.rb", "tests/test_helper.rb"]
  s.homepage = "http://flori.github.com/more_math"
  s.rdoc_options = ["--title", "MoreMath -- More Math in Ruby", "--main", "README.rdoc"]
  s.rubygems_version = "2.5.1"
  s.summary = "Library that provides more mathematics."
  s.test_files = ["tests/cantor_pairing_function_test.rb", "tests/continued_fraction_test.rb", "tests/distribution_test.rb", "tests/functions_test.rb", "tests/histogram_test.rb", "tests/newton_bisection_test.rb", "tests/numberify_string_function_test.rb", "tests/permutation_test.rb", "tests/sequence_moving_average_test.rb", "tests/sequence_test.rb", "tests/string_numeral_test.rb", "tests/subset_test.rb", "tests/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.2.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
      s.add_runtime_dependency(%q<tins>, ["~> 1.0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.2.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
      s.add_dependency(%q<tins>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.2.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
    s.add_dependency(%q<tins>, ["~> 1.0"])
  end
end
