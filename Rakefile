# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'more_math'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://flori.github.com/#{name}"
  summary     'Library that provides more mathematics.'
  description 'Library that provides more mathematical functions/algorithms than standard Ruby.'
  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', 'coverage', '.rvmrc',
    '.AppleDouble', 'tags', '.byebug_history', '.DS_Store'
  readme      'README.rdoc'
  title       "#{name.camelize} -- More Math in Ruby"
  package_ignore '.all_images.yml', '.gitignore', 'VERSION',
    *Dir.glob('.github/**/*', File::FNM_DOTMATCH)

  required_ruby_version '>= 2.0'
  dependency  'tins', '~>1.0'
  dependency  'mize'
  development_dependency 'rake'
  development_dependency 'simplecov'
  development_dependency 'test-unit'
  development_dependency "codeclimate-test-reporter"
  development_dependency 'debug'
  development_dependency 'all_images'
  licenses << 'MIT'
end
