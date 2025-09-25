context do
  variable project_name: Pathname.pwd.basename

  variable project_version: File.read('VERSION').chomp

  namespace "structure" do
    command "tree", tags: %w[ project_structure ]
  end

  namespace "lib" do
    Dir['lib/**/*.rb'].each do |filename|
      file filename, tags: 'lib'
    end
  end

  file 'README.md', tags: 'documentation'
end
