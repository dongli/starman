class Libpng < Package
  url 'https://downloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz'
  sha256 '23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7'

  if OS.mac?
    label :alone
  elsif OS.linux?
    label :skip_if_exist, library_file: 'libpng.so'
  end

  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      CPPFLAGS='-I#{Zlib.link_inc}'
      LDFLAGS='-L#{Zlib.link_lib}'
    ]
    run './configure', *args
    run 'make'
    run 'make', 'test' unless skip_test?
    run 'make', 'install'
  end
end
