class Cmake < Package
  url 'https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz'
  sha256 '8f864e9f78917de3e1483e256270daabc4a321741592c5b36af028e72bff87f5'

  label :common
  label :skip_if_exist, version: lambda { `cmake --version`.match(/(\d+\.\d+\.\d+(\.\d+)?)/)[1] rescue nil }, condition: '>= 3'

  def install
    run './bootstrap', "--prefix=#{prefix}", '--', '-DCMAKE_BUILD_TYPE=Release'
    run 'make'
    run 'make', 'install'
  end
end
