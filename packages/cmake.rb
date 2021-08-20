class Cmake < Package
  url 'https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5.tar.gz'
  sha256 '12c8040ef5c6f1bc5b8868cede16bb7926c18980f59779e299ab52cbc6f15bb0'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3.20'

  def install
    CLI.error 'Use Clang compilers to build CMake!' if OS.mac? and CompilerSet.c.gcc?
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release'
    run 'make'
    run 'make', 'install'
  end
end
