class Zlib < Package
  url 'https://www.zlib.net/zlib-1.2.12.tar.gz'
  sha256 '91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9'

  label :skip_if_exist, library_file: 'libz.so'

  def install
    ENV['CFLAGS'] = '-O3 -fPIC'
    run './configure', "--prefix=#{prefix}"
    run 'make', 'install'
  end
end
