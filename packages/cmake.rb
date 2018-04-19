class Cmake < Package
  url 'https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz'
  sha256 '80d0faad4ab56de07aa21a7fc692c88c4ce6156d42b0579c6962004a70a3218b'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3'

  def install
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release'
    run 'make'
    run 'make', 'install'
  end
end
