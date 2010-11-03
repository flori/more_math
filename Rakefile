begin
  require 'rake/gempackagetask'
rescue LoadError
end
require 'rake/clean'
require 'rbconfig'
include Config

PKG_NAME = 'more_math'
PKG_VERSION = File.read('VERSION').chomp
PKG_FILES = FileList['**/*'].exclude(/^(doc|CVS|pkg|coverage)/)
CLEAN.include 'coverage', 'doc'
CLOBBER.include FileList['data/*']

desc "Run unit tests"
task :test do
  sh %{RUBYOPT="-Ilib $RUBYOPT" testrb tests/*.rb}
end

desc "Testing library with coverage"
task :coverage do
  sh 'rcov -x tests -Ilib tests/*.rb'
end

desc "Installing library"
task :install  do
  ruby 'install.rb'
end

desc "Creating documentation"
task :doc do
  ruby 'make_doc.rb'
end

if defined? Gem
  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.summary =  "Library that provides more mathematics."
    s.description = "Library that provides more mathematical functions/algorithms than standard Ruby."
    s.add_dependency('spruz', '=0.2.1')

    s.files = PKG_FILES

    s.require_path = 'lib'

    s.has_rdoc = true
    s.rdoc_options <<
      '--title' <<  'MoreMath -- More Math in Ruby' << '--main' << 'README'
    s.extra_rdoc_files << 'README'
    s.test_files = Dir['tests/*.rb']

    s.author = "Florian Frank"
    s.email = "flori@ping.de"
    s.homepage = "http://flori.github.com/#{PKG_NAME}"
    s.rubyforge_project = PKG_NAME
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
    pkg.package_files += PKG_FILES
  end
end

desc m = "Writing version information for #{PKG_VERSION}"
task :version do
  puts m
  File.open(File.join('lib', PKG_NAME, 'version.rb'), 'w') do |v|
    v.puts <<EOT
module MoreMath
  # MoreMath version
  VERSION         = '#{PKG_VERSION}'
  VERSION_ARRAY   = VERSION.split(/\\./).map { |x| x.to_i } # :nodoc:
  VERSION_MAJOR   = VERSION_ARRAY[0] # :nodoc:
  VERSION_MINOR   = VERSION_ARRAY[1] # :nodoc:
  VERSION_BUILD   = VERSION_ARRAY[2] # :nodoc:
end
EOT
  end
end

task :default => [ :version, :test ]

task :release => [ :clobber, :version, :package ]
