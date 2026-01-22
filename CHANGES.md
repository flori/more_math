# Changes

## 2026-01-22 v1.11.0

- Added new entropy helper methods: `entropy_probabilities`,
  `entropy_per_symbol`, `minimum_entropy_per_symbol`,
  `collision_entropy_per_symbol`, `entropy_total`, `minimum_entropy_total`, and
  `collision_entropy_total` to `lib/more_math/entropy.rb`
- Replaced the old `entropy` method with an alias to `entropy_per_symbol`
- Updated documentation for `entropy_ratio` to clarify the `size:` keyword
  argument
- Removed the `entropy_ratio_minimum` method and its corresponding test cases
  from the codebase
- Enhanced test coverage in `tests/entropy_test.rb` with new unit tests for the
  added helper methods
    - Updated existing test assertions to use `assert_in_delta` for floating-point
      comparisons
    - Added descriptive comments to the test `setup` method
    - Ensured all new methods return correct values for empty, uniform, and
      varied symbol strings
- Corrected example values in `entropy_ratio` documentation

## 2026-01-19 v1.10.0

- Added new `entropy_maximum` method to calculate theoretical maximum entropy
  for a text given an alphabet size
- Made `size` parameter required in `entropy_ratio` and `entropy_ratio_minimum`
  methods instead of defaulting to `text.size`
- Updated YARD documentation to clarify that `size` parameter represents
  alphabet size
- Modified examples to use explicit alphabet sizes for better clarity
- All entropy methods now consistently return values in bits as expected for
  Shannon entropy
- Updated documentation examples to use simplified method calls without
  `MoreMath::Entropy` prefix
- Enhanced `entropy_maximum` method documentation to explain its use in
  determining security strength for tokens
- Added comprehensive tests for `entropy_maximum` function covering edge cases
  and various alphabet sizes
- Improved `entropy_maximum` method signature to return `0` for invalid
  alphabet sizes (≤ 1) and use `Math.log2` for calculation
- Updated existing entropy method documentation to clarify it calculates
  entropy in bits
- Simplified example code in documentation to use direct method calls instead
  of module prefixes

## 2026-01-16 v1.9.0

- Added support for array inputs in entropy calculation methods by checking
  `text.respond_to?(:chars)` and using raw arrays when appropriate
- Added `MoreMath::Entropy.entropy_ratio_minimum` method to provide
  conservative lower bound accounting for sampling error
- Updated `entropy_ratio` method to use `text.size` instead of
  `text.each_char.size` for consistency
- Added comprehensive tests for new minimum entropy
  ratio methods

## 2026-01-15 v1.8.0

- Added tests for `entropy_ratio` and `lambert_w` method inclusion/extension
- Extended `MoreMath::Functions` module with `Entropy` and `Lambert` modules
  using `extend` instead of `include`
- Updated test execution command to use `bundle exec`
- Updated gem dependencies and version requirements:
  - Updated `rubygems` version requirement from **4.0.2** to **4.0.3**
  - Changed `gem_hadar` development dependency from version constraint "~>
    2.10" to ">= 2.17.0"
  - Maintained compatibility with Ruby **2.0** and later versions
- Added changelog configuration to Rakefile with `filename` set to `CHANGES.md`
- Updated Ruby version from 4.0-rc-alpine to 4.0-alpine

## 2025-12-19 v1.7.0

- Updated `bundle update` command to `bundle update --all` in `.all_images.yml`
- Added `ruby:4.0-rc-alpine` image configuration to `.all_images.yml`
- Added `lib/more_math/lambert.rb` to `s.extra_rdoc_files` and `s.files` in
  `more_math.gemspec`
- Added `tests/lambert_test.rb` to `s.test_files` in `more_math.gemspec`
- Updated `s.rubygems_version` from **3.6.9** to **4.0.2** in
  `more_math.gemspec`
- Updated `s.add_development_dependency` for `gem_hadar` from "~> 2.7" to "~>
  2.10" in `more_math.gemspec`
- Added `openssl-dev` to the list of packages installed by `apk add` in
  `.all_images.yml`
- Rely on `test_helper` requiring `more_math`
- Added `MoreMath::Lambert` module with `lambert_w` method for principal branch
- Integrated `MoreMath::Lambert` into `MoreMath::Functions` module
- Included comprehensive test suite in `TestLambertW` class
- Added YARD documentation with examples and parameter descriptions
- Required `more_math/lambert` in `more_math/functions.rb`
- Supported special cases: W(0)=0, W(∞)=∞, W(-1/e)=-1
- Verified solution property: W(y)·e^(W(y)) = y
- Handled domain error for y < -1/e with NaN return
- Used `MoreMath::NewtonBisection` for robust numerical root finding
- Tests cover values: 0, 1, 100, 0.1, 1000 with expected results
- Tested convergence verification and edge cases

## 2025-09-30 v1.6.0

- Replaced detailed feature sections in README with a concise bullet list of
  MoreMath capabilities
- Added documentation link to GitHub.io and updated installation instructions
  to include both RubyGems and Bundler
- Improved author and license formatting with proper markdown links
- Added `.github/workflows/static.yml` to automate documentation generation and
  deployment using Ruby **3.4**
- Updated `Rakefile` to register new documentation workflow with GemHadar
- Configured workflow to use Ruby **3.4** for documentation builds and deploy
  to GitHub Pages on master branch pushes
- Added `context_spook` as development dependency for YARD documentation
- Added `cscope.out` to `.gitignore` and updated `Rakefile` to include it in
  the ignore list
- Added `code_indexer` configuration to `.utilsrc` with a list of gems
  including **base64**, **bigdecimal**, **date**, **json**, **mize**,
  **ostruct**, **rake**, **stringio**, **sync**, **test-unit**, and **tins**
- Added `doc` and `.yardoc` directories to gitignore and rake configuration
- Updated homepage URL to escape underscore character for proper rendering
- Updated `gem_hadar` development dependency from version **2.4** to **2.6**
- Modified `package_ignore` in Rakefile to explicitly include `.github` and
  `.contexts` directories instead of using glob pattern `*.github/**/*`
- Enhanced documentation for all methods in MoreMath module
- Added documentation directories `.yardoc` and `doc` to `prune_dirs` in
  utilsrc

## 2025-09-11 v1.5.0

- Updated `VERSION` file and `lib/more_math/version.rb` from version **1.4.0** to **1.5.0**
- Added new `more_math.gemspec` file with version **1.5.0**
- Set required Ruby version to **>= 2.0**
- Added development dependencies including `gem_hadar` (**~> 2.4**) and `tins` (**~> 1**)
- Added runtime dependency on `mize` (">= 0")
- Set rubygems version to **3.6.9**
- Included all library files in `s.files` and `s.extra_rdoc_files`
- Set homepage to "https://github.com/flori/more\_math"
- Set license to "MIT"
- Added `yaml-dev` to dockerfile build dependencies
- Installed `bundler` and `gem_hadar` gems in dockerfile
- Updated bundle command to `bundle update` and added `--jobs` option
- Added `fail_fast: true` to CI configuration
- Added `.bundle` to `.gitignore` file
- Included `.bundle` in Rakefile ignore list
- Replaced `Dir.glob('.github/**/*', File::FNM_DOTMATCH)` with `Dir['.github/**/*']`
- Updated `tins` dependency version from `~>1.0` to `~>1`
- Removed deprecated `more_math.gemspec` file
- Replaced simplecov setup with `gem_hadar/simplecov` require and start call

## 2025-07-12 v1.4.0

* Updated `project` method in Subset class with associated tests
  + Maps dataset elements based on subset indices
  + Ensures data size validation
  + Comprehensive test cases for `project` functionality
* Added a list of features and example usage of the library in README
* Updated bundler behavior to clean up Gemfile.lock before installing gems
* Removed obsolete `binary` option from discover block in utility functions

## 2024-09-30 v1.3.0

* **Added support for displaying histograms based on percentage of terminal width**
  + Added `terminal_width` method to `Histogram` class
  + Updated `display` method to take interpret the `width` parameter as a percentage string, e.g. `75%`
  + Updated test cases to use the new `display` method with different widths
  + Added a new test case for displaying histograms with counts and `75%` width

## 2024-09-30 v1.2.2

### Improvements
* Refactor Histogram display logic for better UTF-8 support:
  + Extracted `output_row_with_count` and `output_row_without_count` methods
  + Updated test cases for histogram display with counts and UTF-8 support
* Update Rakefile to ignore `.utilsrc` file:
  - Add `.utilsrc` to `package_ignore` list in Rakefile

## 2024-09-30 v1.2.1

* Refactor histogram display logic for utf8 and ascii bars
  + *Improved `utf8_bar` method to handle fractional bar widths.*
  + *Updated test case in `histogram_test.rb` to reflect changes.*

## 2024-09-30 v1.2.0

#### Significant Changes

* Bumped version to **1.2.0**
  + Updated `VERSION` in `lib/more_math/version.rb`
  + Updated gemspec version and date
  + Bumped `gem_hadar` development dependency to **1.18.0**
* Update Ruby version check in `.all_images.yml`
  + Added `--full-index` to `bundle` command
* Add UTF-8 support to histogram display
  + Added `utf8?` method to Histogram class
  + Modified `output_row` method to use UTF-8 bars with braille when possible
  + Added tests for UTF-8 histogram display with and without counts

## 2024-08-28 v1.1.0

* **Added** `interquartile_range` method to `MoreMath::Sequence`
  + Significant changes:
    - Added `interquartile_range` method to `MoreMath::Sequence`
    - Updated test cases for `sequence_test.rb`
* **Updated** all_images.yml to include Ruby **3.3**

## 2024-07-03 v1.0.2

* Use github as homepage for rubygems
* Only test newer ruby versions
* Fine tune width settings a bit, and raise error when invalid arguments are provided:
  + Method: `code`**width_settings**
  + Variable: `code`**github_url**

## 2023-05-29 v1.0.1

* **Fine-tuned** the width settings:
  + Raised an error when invalid arguments were provided
* Significant changes:
  * Raised error when `stupid` arguments are given to width settings
  * Updated width settings (no specific details available)

## 2023-05-26 v1.0.0

### Changes in **v1.2**

* Use correct version
* Revert changes made earlier
* Remove codeclimate support
* Add display of counts on right hand side of histogram (twice)
* Use debug now, also all_images
* Cleanup some old files
* Create codeql-analysis.yml
* Use all_images instead of travis
* Be compatible to older rubies
* Adds predicate to check if ContinuedFraction is `#simple?` and add the standard […;…,…] notation for these.
  + Adds ContinuedFraction#reciprocal method.
  + Use keyword arguments for ContinuedFraction approximations instead of positional arguments.
* Add exp log functions as well
* Add erfc unless mixed in from Math already
* Convert number to float b4 calculation
* Compute Z-score sequence from a sequence
* New gemspec created
* Test refinement

## 2019-06-13 v0.4.0

* **Added** `r2` measure to `linear_regression`
* **Updated** testing to include Ruby **2.4.1**

## 2017-07-04 v0.3.3

* Added **1.0** version of the gem with a new feature:
  + Added `code`LICENSE = "MIT"` to Gemfile
  + Updated `code`gemspec.rb` with `code`SPDX-License-Identifier: MIT`
* No significant changes in this commit

## 2017-03-09 v0.3.2

* **Don't shadow if we don't have to**
* Bump version to **1.0**
* Fix some warnings
* Add specs for std dev percentage methods
* Abstract result into a bin structure
* Require ruby version >= 2
* Refactor MoreMath::Histogram using `mize`
* Don't shadow and conserve memory

## 2016-10-20 v0.3.1

* **Corrected method name**
  + Changed `code`**_method_name_** to `code`**_correct_method_name_**

## 2016-10-20 v0.3.0

* **Significant Changes**
  + Bump version to **1.0** (commit)
  + Implement n-element moving average for Sequence in `Sequence` class
  + Add functions to compute entropy of texts in `EntropyCalculator` class
  + Refactor some methods in `continued_fraction.rb`
  + Ignore `.DS_Store` files
* Other changes:
  + Test ruby **2.3.1**
  + Add codeclimate configuration files
  + Add code climate coverage token

## 2015-05-21 v0.2.1

* **Upgrade to newer versions of gem infrastructure**
* **Depend on test-unit gem explicitely**
* **Updates dependencies**
* **More rubies**
* **Test newer rubies**
* **Add rake development dependency**
* **Avoid annoying rubygems warning**

## 2012-11-01 v0.1.0

#### New Features

* Added Permutation features:
  + `identity`: Returns a permutation that leaves all elements unchanged.
  + `power`: Raises a permutation to a given power.
  + `from_mapping`: Creates a permutation from a given mapping.
  Contributed by Pramukta Kumar <prak@mac.com>.

#### Configuration Changes

* Ignore `.AppleDouble` files.
* Configure Travis CI for continuous integration.
* Added `utils` as a development dependency.

## 2011-12-25 v0.0.4

* **Changes for Ruby 1.9.3 and 1.8**
  + Added support for `ruby 1.9.3` as a test target
  + Implemented `to_int` method for symbols in Ruby 1.8
* Renamed test files

## 2011-10-28 v0.0.3

* **Changes in version **bold**0.2.3**bold**:*
  + Added permutation class to more_math
  + Started power set implementation
  + Shared code between subset and permutation
  + Fixed small subset issues
  + Merged branch 'power_set' into power_set
  + Resolved conflicts in lib/more_math.rb, lib/more_math/ranking_common.rb, lib/more_math/subset.rb, and more_math.gemspec

## 2011-09-26 v0.0.2

* **Depend on tins library**
  + Added dependency on `tins` library.

## 2011-07-17 v0.0.1

* Added Travis configuration
* Use `gem_hadar` for building and Rakefile
* Corrected `to_sn` method
* Added more methods to object, fixed coerce method, and added string numeral
* Fixed Ruby 1.9 problems
* Renamed string number functions
* Reorganized code
* Added string numeration functions and logb, log_ceil, log_floor functions
* Used spruz/memoize functionality

### Conflicts Resolved

* `.gitignore`
* `Rakefile`
* `more_math.gemspec`

## 2010-11-01 v0.0.0

  * Start
