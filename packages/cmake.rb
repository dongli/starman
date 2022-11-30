class Cmake < Package
  url 'https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz'
  sha256 '0d9020f06f3ddf17fb537dc228e1a56c927ee506b486f55fe2dc19f69bf0c8db'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3.20'

  def install
    CLI.error 'Use Clang compilers to build CMake!' if OS.mac? and CompilerSet.c.gcc?
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release', '-DCMAKE_USE_OPENSSL=OFF'
    run 'make'
    run 'make', 'install'
  end
end
