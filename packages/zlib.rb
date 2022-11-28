class Zlib < Package
  url 'https://www.zlib.net/zlib-1.2.13.tar.gz'
  sha256 'b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30'

  label :skip_if_exist, library_file: 'libz.so'

  def install
    ENV['CFLAGS'] = '-O3 -fPIC'
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
