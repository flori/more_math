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
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', 'coverage', '.rvmrc', '.AppleDouble'
  readme      'README.rdoc'
  title       "#{name.camelize} -- More Math in Ruby"

  dependency  'tins', '~>1.0'
  development_dependency 'rake'
  development_dependency 'simplecov'
  development_dependency 'test-unit'

  install_library do
    libdir = CONFIG["sitelibdir"]
    file = 'lib/more_math.rb'
    install(file, libdir, :mode => 0644)
    mkdir_p subdir = File.join(libdir, 'more_math')
    for f in Dir['lib/more_math/*.rb']
      install(f, subdir)
    end
    mkdir_p subdir = File.join(libdir, 'more_math', 'constants')
    for f in Dir['lib/more_math/constants/*.rb']
      install(f, subdir)
    end
  end
end
