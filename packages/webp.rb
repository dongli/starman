class Webp < Package
  url 'https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.3.tar.gz'
  sha256 'e20a07865c8697bba00aebccc6f54912d6bc333bb4d604e6b07491c1a226b34f'

  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'libtiff'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-gif
      --disable-gl
      --enable-libwebpdecoder
      --enable-libwebpdemux
      --enable-libwebpmux
      --with-pngincludedir=#{Libpng.link_inc}
      --with-pnglibdir=#{Libpng.link_lib}
      --with-jpegincludedir=#{Jpeg.link_inc}
      --with-jpeglibdir=#{Jpeg.link_lib}
      --with-tiffincludedir=#{Libtiff.link_inc}
      --with-tifflibdir=#{Libtiff.link_lib}
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
