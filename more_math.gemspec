# -*- encoding: utf-8 -*-
# stub: more_math 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "more_math".freeze
  s.version = "1.2.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2024-09-30"
  s.description = "Library that provides more mathematical functions/algorithms than standard Ruby.".freeze
  s.email = "flori@ping.de".freeze
  s.extra_rdoc_files = ["README.md".freeze, "lib/more_math.rb".freeze, "lib/more_math/cantor_pairing_function.rb".freeze, "lib/more_math/constants/functions_constants.rb".freeze, "lib/more_math/continued_fraction.rb".freeze, "lib/more_math/distributions.rb".freeze, "lib/more_math/entropy.rb".freeze, "lib/more_math/exceptions.rb".freeze, "lib/more_math/functions.rb".freeze, "lib/more_math/histogram.rb".freeze, "lib/more_math/linear_regression.rb".freeze, "lib/more_math/newton_bisection.rb".freeze, "lib/more_math/numberify_string_function.rb".freeze, "lib/more_math/permutation.rb".freeze, "lib/more_math/ranking_common.rb".freeze, "lib/more_math/sequence.rb".freeze, "lib/more_math/sequence/moving_average.rb".freeze, "lib/more_math/sequence/refinement.rb".freeze, "lib/more_math/string_numeral.rb".freeze, "lib/more_math/subset.rb".freeze, "lib/more_math/version.rb".freeze]
  s.files = ["CHANGES.md".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "lib/more_math.rb".freeze, "lib/more_math/cantor_pairing_function.rb".freeze, "lib/more_math/constants/functions_constants.rb".freeze, "lib/more_math/continued_fraction.rb".freeze, "lib/more_math/distributions.rb".freeze, "lib/more_math/entropy.rb".freeze, "lib/more_math/exceptions.rb".freeze, "lib/more_math/functions.rb".freeze, "lib/more_math/histogram.rb".freeze, "lib/more_math/linear_regression.rb".freeze, "lib/more_math/newton_bisection.rb".freeze, "lib/more_math/numberify_string_function.rb".freeze, "lib/more_math/permutation.rb".freeze, "lib/more_math/ranking_common.rb".freeze, "lib/more_math/sequence.rb".freeze, "lib/more_math/sequence/moving_average.rb".freeze, "lib/more_math/sequence/refinement.rb".freeze, "lib/more_math/string_numeral.rb".freeze, "lib/more_math/subset.rb".freeze, "lib/more_math/version.rb".freeze, "more_math.gemspec".freeze, "tests/cantor_pairing_function_test.rb".freeze, "tests/continued_fraction_test.rb".freeze, "tests/distribution_test.rb".freeze, "tests/entropy_test.rb".freeze, "tests/functions_test.rb".freeze, "tests/histogram_test.rb".freeze, "tests/newton_bisection_test.rb".freeze, "tests/numberify_string_function_test.rb".freeze, "tests/permutation_test.rb".freeze, "tests/sequence/refinement_test.rb".freeze, "tests/sequence_moving_average_test.rb".freeze, "tests/sequence_test.rb".freeze, "tests/string_numeral_test.rb".freeze, "tests/subset_test.rb".freeze, "tests/test_helper.rb".freeze]
  s.homepage = "https://github.com/flori/more_math".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "MoreMath -- More Math in Ruby".freeze, "--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.5.18".freeze
  s.summary = "Library that provides more mathematics.".freeze
  s.test_files = ["tests/cantor_pairing_function_test.rb".freeze, "tests/continued_fraction_test.rb".freeze, "tests/distribution_test.rb".freeze, "tests/entropy_test.rb".freeze, "tests/functions_test.rb".freeze, "tests/histogram_test.rb".freeze, "tests/newton_bisection_test.rb".freeze, "tests/numberify_string_function_test.rb".freeze, "tests/permutation_test.rb".freeze, "tests/sequence/refinement_test.rb".freeze, "tests/sequence_moving_average_test.rb".freeze, "tests/sequence_test.rb".freeze, "tests/string_numeral_test.rb".freeze, "tests/subset_test.rb".freeze, "tests/test_helper.rb".freeze]

  s.specification_version = 4

  s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.18.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<debug>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<all_images>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<tins>.freeze, ["~> 1.0".freeze])
  s.add_runtime_dependency(%q<mize>.freeze, [">= 0".freeze])
end
