# Changes

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
