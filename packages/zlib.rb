class Zlib < Package
  url 'https://zlib.net/zlib-1.2.11.tar.gz'
  mirror 'https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz'
  sha256 'c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1'

  def install
    ENV['CFLAGS'] = '-O3 -fPIC'
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
