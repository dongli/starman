class Cmake < Package
  url 'https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz'
  sha256 'acbf13af31a741794106b76e5d22448b004a66485fc99f6d7df4d22e99da164a'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3'

  def install
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release'
    run 'make'
    run 'make', 'install'
  end
end
