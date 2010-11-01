#!/usr/bin/env ruby

puts "Creating documentation."
system "rdoc --main README --title 'MoreMath -- More Math in Ruby'"\
  " -d #{Dir['lib/**/*.rb'] * ' '} README"
