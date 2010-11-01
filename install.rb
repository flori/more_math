#!/usr/bin/env ruby

require 'rbconfig'
require 'fileutils'
include FileUtils::Verbose

include Config

file = 'lib/more_math.rb'
libdir = CONFIG["sitelibdir"]
install(file, libdir, :mode => 0755)
mkdir_p subdir = File.join(libdir, 'more_math')
for f in Dir['lib/more_math/*.rb']
  install(f, subdir)
end
mkdir_p subdir = File.join(libdir, 'more_math', 'constants')
for f in Dir['lib/more_math/constants/*.rb']
  install(f, subdir)
end
