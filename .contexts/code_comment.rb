context do
  namespace "lib" do
    Dir['lib/**/*.rb'].each do |filename|
      file filename, tags: 'lib'
    end
  end


  file 'README.md', tags: 'documentation'

  file '.contexts/yard.md', tags: [ 'yard', 'cheatsheet' ]

  meta guidelines: <<~EOT
    # Guidelines for creating YARD documentation

    - Look into the file, with tags yard and cheatsheet for how comment ruby
      constructs.
    - In comments above initialize methods **ALWAYS** omit @return.
    - **NEVER** output @return [ void ] in comments of any method, because
      in Ruby every method returns something. If you don't know or if the
      method is just called because its side effect just omit the @return.
  EOT
end
