# Changes

## 2026-11-19 v1.12.0

### Documentation
- Replaced the YARD cheatsheet in `.contexts/yard.md` with a concrete
  documentation-only example, adding rules to generate `#` prefixed
  comments without executable Ruby code and including YARD directives
  like `@!attribute`, `@param`, and `@deprecated`.
- Removed vim modelines from `Gemfile` and `Rakefile`.

## 2026-01-22 v1.11.0

### Features
- Added new entropy helper methods: `entropy_probabilities`, `entropy_per_symbol`, `minimum_entropy_per_symbol`, `collision_entropy_per_symbol`,
  `entropy_total`, `minimum_entropy_total`, and `collision_entropy_total`.
- Replaced the old `entropy` method with an alias to `entropy_per_symbol`.

### Breaking
- Removed the `entropy_ratio_minimum` method and its associated test cases.

### Improvements
- Corrected example values in the `entropy_ratio` documentation.

### Testing
- Extended `tests/entropy_test.rb` with new unit tests for the added helper methods.
- Updated existing test assertions to use `assert_in_delta` for floating-point comparisons.

## 2026-01-19 v1.10.0

### Breaking
- The `size` parameter is now required for the
  `entropy_ratio` and `entropy_ratio_minimum` methods, removing
  the previous default behavior.

### Features
- Added `entropy_maximum` method to calculate the theoretical
  maximum entropy in bits for a given text and alphabet size.

### Improvements
- Updated documentation to clarify that entropy values are
  returned in bits and that the `size` parameter represents
  the alphabet size.
- Simplified documentation examples to use direct method calls
  without module prefixes.
- Enhanced `entropy_maximum` documentation to explain its
  application in determining token security strength.

### Testing
- Added tests for `entropy_maximum` covering edge cases such as
  invalid alphabet sizes and various valid sizes.
- Updated `entropy_ratio` tests to explicitly pass the `size`
  parameter.

## 2026-01-16 v1.9.0

### Features
- Added support for array inputs in entropy calculation methods by
  checking `text.respond_to?(:chars)` and using raw arrays when
  appropriate.
- Added `MoreMath::Entropy.entropy_ratio_minimum` method to provide a
  conservative lower bound accounting for sampling error.

### Improvements
- Updated `entropy_ratio` method to use `text.size` instead of
  `text.each_char.size` for consistency.

### Testing
- Added comprehensive tests for new minimum entropy ratio methods.
- Moved `tests/sequence/refinement_test.rb` to
  `tests/sequence_refinement_test.rb`.

### Build & CI
- Corrected the gemspec file and test file listings to match the
  updated test directory structure.

## 2026-01-15 v1.8.0

### Fixes
- Changed `include` to `extend` for the `Entropy` and `Lambert`
  modules in `MoreMath::Functions` to correctly expose methods as
  module-level functions.

### Build & CI
- Updated `rubygems` version requirement from **4.0.2** to **4.0.3**.
- Relaxed `gem_hadar` development dependency constraint from "~> 2.10"
  to ">= 2.17.0".
- Updated CI image from `ruby:4.0-rc-alpine` to `ruby:4.0-alpine`.
- Added `changelog` configuration block to the Rakefile with `filename`
  set to `CHANGES.md`.
- Changed test execution script in `.all_images.yml` to use `bundle
  exec rake test`.

### Testing
- Added tests to verify `entropy_ratio` and `lambert_w` are available
  as module methods and instance methods in `MoreMath::Functions`.

## 2025-12-19 v1.7.0

### Features
- Added the `MoreMath::Lambert` module, providing a `lambert_w` method for
  the principal branch of the Lambert W function.
- Integrated `MoreMath::Lambert` into the `MoreMath::Functions` module.
- Added `MoreMath::Lambert` to the gemspec file lists and RDoc configuration.

### Improvements
- Removed redundant `require 'more_math'` statements from existing test files,
  relying instead on the `test_helper`.

### Testing
- Added a `TestLambertW` test suite covering standard values, convergence, and
  edge cases such as domain errors.

### Build & CI
- Updated the bundle command to `bundle update --all` in `.all_images.yml`.
- Added a `ruby:4.0-rc-alpine` image configuration to the CI matrix.
- Added `openssl-dev` to the Alpine Linux packages installed in the CI
  Dockerfile to support native extensions.
- Updated the `gem_hadar` development dependency constraint to `~> 2.10`.
- Updated the `rubygems_version` metadata in the gemspec to **4.0.2**.

## 2025-09-30 v1.6.0

### Improvements
- Updated the `Permutation` class to correctly implement the `<=>` comparison
  method, ensuring accurate lexicographic ordering by size and rank.
- Replaced `clone` with `dup` in the `Permutation#project` method to avoid
  sharing mutable state with the original data object.
- Corrected the `Subset#value` method iteration to properly process all
  elements in the set, fixing an off-by-one error.

### Documentation
- Enhanced YARD documentation across all library modules, adding detailed
  method descriptions, parameter specifications, return types, and usage
  examples.
- Replaced detailed feature sections in the README with a concise bullet list
  of `MoreMath` capabilities.
- Updated installation instructions to include usage with both RubyGems and
  Bundler.
- Added a link to the GitHub.io documentation site in the README.
- Improved formatting for author and license information in the README.

### Build & CI
- Added a GitHub Actions workflow to automate documentation generation and
  deployment to GitHub Pages on pushes to the master branch.
- Updated `gem_hadar` development dependency from version **2.4** to
  **2.7**.
- Added `context_spook` as a development dependency for YARD documentation
  support.
- Configured `.gitignore` and `Rakefile` to ignore documentation artifacts
  such as `cscope.out`, `doc`, and `.yardoc` directories.
- Added `code_indexer` configuration to `.utilsrc` to support cscope indexing
  of project dependencies.
- Modified `Rakefile` package ignore settings to explicitly list `.github` and
  `.contexts` directories instead of using glob patterns.
- Updated the homepage URL in `CHANGES.md` to escape the underscore character
  for proper markdown rendering.

## 2025-09-11 v1.5.0

### Improvements
- Replaced manual `SimpleCov` initialization with
  `GemHadar::SimpleCov` in `tests/test_helper.rb`.

### Build & CI
- Added `yaml-dev` to the Docker build dependencies.
- Updated the Docker CI script to install `bundler` and
  `gem_hadar`, use `bundle update`, and run `bundle install`
  with parallel jobs.
- Configured the CI runner with `fail_fast: true`.
- Removed the `ruby:3.0-alpine` image from the CI matrix.
- Relaxed the `tins` runtime dependency constraint in the
  `Rakefile` from `~> 1.0` to `~> 1`.
- Added `.bundle` to `.gitignore` and the `Rakefile` ignore
  list.
- Refactored the `Rakefile` to use `Dir['.github/**/*']`
  instead of `Dir.glob` with `File::FNM_DOTMATCH`.
- Updated the gemspec to include the new `tins` and
  `gem_hadar` dependency versions.

## 2025-07-12 v1.4.0

### Features
- Add `project` method to `Subset` class, allowing dataset elements
  to be mapped based on subset indices with size validation.

### Build & CI
- Remove obsolete `binary` option from the discover block in `.utilsrc`.
- Remove unnecessary `gem update` and `gem install` commands from the
  Dockerfile.
- Add support for Ruby **3.4** in the CI image definitions.
- Update bundler behavior to remove `Gemfile.lock` before installing gems
  in the test script.
- Update `rubygems_version` in the gemspec to **3.6.9**.

### Testing
- Add comprehensive test cases for the `Subset#project` method.
- Update histogram test cases to explicitly specify width parameters and
  include a test for percentage-based width display.

### Documentation
- Update README with a detailed list of core features, specialized
  modules, and example usage code for the library.
- Reformat the existing changelog entries in `CHANGES.md` for consistent
  indentation.

## 2024-10-01 v1.3.0

### Breaking
- Changed the default `width` for `display` from `50` to `65`
- The `width` parameter now requires a minimum value of `15`

### Features
- Added support for displaying histograms based on percentage of terminal width
- Added `terminal_width` method to `Histogram` class

### Improvements
- Added `tins` dependency to support terminal width detection

## 2024-09-30 v1.2.2

### Improvements
- Refactored `Histogram` display logic, extracting `output_row_with_count` and `output_row_without_count` methods to improve UTF-8 support.
- Added `.utilsrc` to the `package_ignore` list in the `Rakefile` to exclude it from packaging.

### Testing
- Added test cases for `Histogram` display with counts and UTF-8 support.

## 2024-09-30 v1.2.1

### Improvements
- Improved the `utf8_bar` method to append a space when the fractional
  bar width is less than or equal to 0.5, and adjusted the `display`
  method to account for this trailing space in width calculations.

### Testing
- Updated the histogram display tests to verify the new trailing space
  behavior in the bar rendering.

## 2024-09-30 v1.2.0

### Features
- Added UTF-8 support to histogram display, utilizing braille
  characters for finer-grained bar representation when the locale
  permits.

### Build & CI
- Updated the `bundle` command in `.all_images.yml` to use the
  `--full-index` flag.

### Testing
- Added tests for UTF-8 histogram display, including scenarios
  with and without count labels.

### Documentation
- Converted `CHANGES` to `CHANGES.md` and updated the gemspec
  file list accordingly.

## 2024-08-28 v1.1.0

### Features
- Added `interquartile_range` method to the
  `MoreMath::Sequence` class.

### Build & CI
- Added support for **3.3** Ruby in the CI test
  matrix.
- Updated the `gem_hadar` development dependency
  to version **~> 1.17.0**.

### Testing
- Added test cases for the new
  `interquartile_range` method in `sequence_test.rb`.

## 2024-07-03 v1.0.2

### Fixes
- Raise `ArgumentError` in `display` when `width` is less
  than `1`.
- Clamp `left_width` to `width` if negative.
- Use `round` instead of `ceil` for `bar_width` calculation.

### Build & CI
- Update homepage to `https://github.com/flori/more_math`.
- Update `gem_hadar` dependency to **1.15.0**.
- Test only Ruby **3.0** and newer.

## 2023-05-29 v1.0.1

### Improvements
- Added `ArgumentError` validation in `display` to ensure `width` is `>= 1`.
- Changed bar width calculation in `output_row` to use `.round` instead of `.ceil`.
- Adjusted `left_width` to reset to `width` if it calculates as negative.

## 2023-05-26 v1.0.0

### Breaking
- Changed `MoreMath::ContinuedFraction#call`,
  `MoreMath.beta_regularized`, `MoreMath.gammaP_regularized`,
  and `MoreMath.gammaQ_regularized` to use keyword arguments for
  `epsilon` and `max_iterations` instead of positional parameters.

### Features
- Added `with_counts` option to `MoreMath::Histogram` to display
  bar counts on the right-hand side of the histogram.
- Added `MoreMath::Sequence#z_score` to compute the Z-score sequence
  from a sequence.
- Added `MoreMath::ContinuedFraction#simple?` predicate and `to_s`
  method to display standard continued fraction notation.
- Added `MoreMath::ContinuedFraction#reciprocal` method.
- Added `MoreMath::ContinuedFraction.from` class method to create an
  instance from a rational number.
- Added `MoreMath.gamma` and `MoreMath.beta` methods for computing
  gamma and beta function values.
- Added `MoreMath::erfc` for compatibility with Ruby versions that
  do not include `Math#erfc`.

### Fixes
- Updated `MoreMath::ContinuedFraction#each` to use
  `Float::INFINITY` for compatibility with older Ruby versions.
- Ensured `MoreMath::log_gamma` converts input to float before
  calculation.

### Improvements
- Removed CodeClimate support and associated configuration files.
- Replaced Travis CI with `all_images` for container-based testing.
- Renamed `README.rdoc` to `README.md` and updated gemspec
  references.
- Removed `byebug` in favor of the `debug` gem.

### Build & CI
- Added CodeQL analysis workflow.
- Updated supported Ruby versions in `all_images` configuration,
  adding Ruby 3.2 and removing Ruby 2.5.

## 2019-06-13 v0.4.0

### Breaking
- Renamed the `residues` method in `linear_regression` to `residuals`.

### Features
- Added an `r2` method to `linear_regression` to calculate the
  coefficient of determination.

### Fixes
- Corrected the `linear_regression` computation to use the provided
  domain values without modifying them.

### Build & CI
- Updated the supported Ruby versions in CI to include **2.3**,
  **2.4**, **2.5**, and **2.6**.

### Testing
- Added test coverage for the new `r2` method in `linear_regression`.
- Updated existing tests to use the renamed `residuals` method and
  adjusted test data and expectations.

## 2017-07-04 v0.3.3

### Build & CI
- Set the SPDX short identifier of the license to MIT in the gemspec
  and Rakefile.

## 2017-03-09 v0.3.2

### Breaking
- `Histogram#to_a` now returns an array of `Bin` objects instead of arrays.

### Features
- Added `Histogram#each_bin` and `Histogram#counts` methods to facilitate
  iterating over histogram data.

### Fixes
- Fixed a variable shadowing issue in `MoreMath::Functions#beta_regularized`
  by renaming the block argument in `ContinuedFraction` blocks.
- Fixed a variable shadowing issue in `MoreMath::Functions#gammaQ_regularized`
  by renaming block arguments.
- Fixed a variable shadowing issue in `Histogram#prepare_display`.
- Resolved Ruby warning about shadowing outer local variable in
  `Permutation#project` by guarding `@collection` access.
- Fixed `Sequence#detect_autocorrelation` to explicitly return the
  signal-to-noise ratio.

### Improvements
- Replaced `tins` memoization with the `mize` gem for `Sequence` and
  `NumberifyStringFunction` methods.
- Removed redundant `require 'more_math'` statements from library files to
  reduce circular dependency warnings.

### Build & CI
- Added Ruby **2.4.0** to the Travis CI test matrix.
- Removed Code Climate addons from the Travis CI configuration.
- Added `codeclimate-test-reporter` as a development dependency.
- Set the minimum required Ruby version to **2.0**.

### Testing
- Added tests for `Sequence#standard_deviation_percentage` and
  `Sequence#sample_standard_deviation_percentage`.
- Updated `Histogram` tests to use the new `Bin` structure methods.

## 2016-10-20 v0.3.1

### Fixes
- Rename `entropy_percentage` to `entropy_ratio` to better reflect its functionality.

## 2016-10-20 v0.3.0

### Features
- Added the `MoreMath::Entropy` module with methods `entropy`,
  `entropy_ideal`, and `entropy_percentage` to compute text entropy
  metrics.
- Added the `simple_moving_average` (alias `moving_average`) method to
  `MoreMath::Sequence` to calculate n-element moving averages.
- Added the `to_ary` (alias `to_a`) and `push` (alias `<<`) methods to
  `MoreMath::Sequence` for array-like interface compatibility.
- Added a Ruby refinement providing a `to_seq` method for `::Object`
  within `MoreMath::Sequence::Refinement`.

### Improvements
- Refactored `MoreMath::ContinuedFraction` to extract shared argument
  parsing logic into a private `for_arg` helper.
- Refactored `MoreMath::ContinuedFraction` to extract value retrieval
  logic into a private `value` helper.

### Build & CI
- Bumped the `gem_hadar` development dependency requirement from **1.2.1**
  to **1.9.1**.
- Added Ruby **2.3.1** to the Travis CI test matrix.
- Added Code Climate coverage integration to the Travis CI configuration.
- Added `.codeclimate.yml` and `.rubocop.yml` configuration files for
  static analysis.
- Added `byebug` as a development dependency for MRI platforms.
- Added `.DS_Store` and `.byebug_history` to the `.gitignore` file and
  Rakefile ignore patterns.

## 2015-05-21 v0.2.1

### Build & CI
- Dropped support for Ruby versions older than `2.0` and added
  coverage for `2.1`, `2.2`, and `jruby-head` in the Travis CI
  configuration.
- Updated development dependencies by replacing `utils` with
  `simplecov` and `rake`, and bumping `tins` to `~> 1.0`.
- Added `test-unit` as an explicit development dependency.
- Removed the custom `install_library` task from the `Rakefile`.
- Updated the `Gemfile` source to use `https://rubygems.org` to
  suppress RubyGems warnings.
- Added `tags` to the `.gitignore` file and Rake ignore patterns.

## 2012-11-01 v0.1.0

### Features
- Added `Permutation.identity` to generate the identity
  permutation of a given size or matching an instance.
- Added `Permutation.for_mapping` to construct a permutation
  that maps one sequence of elements into another.
- Added `Permutation#power` to compute the nth power of a
  permutation, including negative powers via the inverse.

### Improvements
- Modified `Permutation.from_value` to clone the input indices
  to prevent mutation of the caller's array.
- Updated `.travis.yml` to use specific `rbx` and `jruby`
  modes and allow failures for `ruby-head`.

### Build & CI
- Added `utils` as a development dependency.
- Updated `gem_hadar` development dependency to require
  version **0.1.8** or newer.
- Added `.AppleDouble` to `.gitignore` and the `Rakefile`
  ignore list.

### Testing
- Added tests for `Permutation#identity`,
  `Permutation.for_mapping`, and `Permutation#power`.

## 2011-12-25 v0.0.4

### Fixes
- Handle `Symbol` arguments in `StringNumeral.from` to prevent conversion errors on
  Ruby 1.8.
- Replace strict equality check with floating-point tolerance in
  `MoreMath::Distributions` to accurately identify the median probability.

### Improvements
- Implement `eql?`, `hash`, `to_int`, and `to_str` methods for
  `MoreMath::StringNumeral` to support standard comparison and type conversion
  interfaces.

### Testing
- Add `simplecov` as a development dependency and update test files to use a
  shared `test_helper` module.
- Add tests for `MoreMath::StringNumeral` and expand coverage for
  `MoreMath::ContinuedFraction`, `MoreMath::Sequence`, and `MoreMath::Subset`.

### Build & CI
- Add Ruby 1.9.3 to the list of versions tested by Travis CI.
- Update `gem_hadar` dependency constraint to `~> 0.1.4`.

## 2011-10-28 v0.0.3

### Breaking
- Replace the `PowerSet` class with a new `Subset` class for
  subset enumeration.
- Refactor the `Permutation` class to use the new `RankingCommon`
  module for shared iteration logic.

### Features
- Add `Permutation` class providing methods for generating,
  composing, inverting, and ranking permutations.
- Add `Subset` class providing methods for generating, ranking,
  and iterating over subsets of a collection.

### Improvements
- Extract shared ranking and iteration logic into a new
  `RankingCommon` module to reduce code duplication between
  `Permutation` and `Subset`.

### Testing
- Add test coverage for the new `Permutation` and `Subset` classes.
- Rename `test_analysis.rb` to `test_sequence.rb` to better
  reflect its content.

### Build & CI
- Update the development dependency for `gem_hadar` to `~> 0.1.1`.
- Update `.gitignore` to exclude `.rvmrc` and `coverage` directories.
- Update `Rakefile` to ignore `.rvmrc` and `coverage` in package
  listings.

## 2011-09-26 v0.0.2

### Improvements
- Replaced the dependency on the `spruz` library with `tins` ~> **0.3**.
- Updated the development dependency on `gem_hadar` to ~> **0.1.0**.

## 2011-07-17 v0.0.1

### Features
- Added `MoreMath::StringNumeral` class for converting between numbers and
  string representations using a customizable alphabet.
- Added `numberify_string` and `stringify_number` functions to the
  `MoreMath::Functions` module for bidirectional string-number conversion.
- Added `log_ceil`, `log_floor`, and `logb` utility functions to the
  `MoreMath::Functions` module.

### Fixes
- Corrected the `StringNumeral` `coerce` method to return the naturalized
  other object first, ensuring proper numeric comparison behavior.
- Updated the `to_sn` method to accept an optional alphabet argument and
  prevent unnecessary re-initialization if the object is already a
  `StringNumeral`.
- Fixed Ruby 1.9 compatibility issues by guarding the `Infinity` constant
  definition and correcting the test execution path in the Rakefile.

### Improvements
- Renamed the `NumerateStringFunction` module to `NumberifyStringFunction`
  and updated corresponding method names for consistency.
- Refactored the `Sequence` class to use `spruz/memoize` for caching
  statistical values, removing manual instance variable caching.
- Added a `reset` method to `Sequence` to clear memoized values.
- Added a `sorted` method to `Sequence` to return a sorted copy of elements.

### Build & CI
- Added Travis CI configuration to test against multiple Ruby versions,
  including JRuby and Rubinius.
- Migrated build automation from manual Rake tasks to `gem_hadar`.
- Removed obsolete `install.rb` and `make_doc.rb` scripts.
- Updated the `Gemfile` and gemspec to manage dependencies via `Bundler` and
  the `gemspec` directive.
- Changed the primary dependency from `dslkit` to `spruz`.

### Testing
- Added tests for `NumberifyStringFunction` covering `log_ceil`,
  `log_floor`, and string-number conversion logic.
- Added tests for the new `StringNumeral` class.

### Documentation
- Renamed `README` to `README.rdoc` to enable proper RDoc rendering.

## 2010-11-01 v0.0.0

  * Start
