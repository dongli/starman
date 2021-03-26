class Cmake < Package
  url 'https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz'
  sha256 '8a211589ea21374e49b25fc1fc170e2d5c7462b795f1b29c84dd0e984301ed7a'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3.12'

  def install
    CLI.error 'Use Clang compilers to build CMake!' if OS.mac? and CompilerSet.c.gcc?
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release'
    run 'make'
    run 'make', 'install'
  end
end
