require 'gem_hadar'

gem_hadar = GemHadar.new do
  name        'more_math'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    'http://github.com/flori/more_math'
  summary     'Library that provides more mathematics.'
  description 'Library that provides more mathematical functions/algorithms than standard Ruby.' 
  test_dir    'tests'
  clobber     FileList['data/*']
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock'
  title       'MoreMath -- More Math in Ruby'
  readme      'README.rdoc'

  dependency  'spruz', '~>0.2'

  install_library do
    libdir = CONFIG["sitelibdir"]
    install('lib/more_math.rb', libdir, :mode => 0644)
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
