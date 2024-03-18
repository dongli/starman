class Libtiff < Package
  url 'https://download.osgeo.org/libtiff/tiff-4.6.0.tar.gz'
  sha256 '88b3979e6d5c7e32b50d7ec72fb15af724f6ab2cbf7e10880c360a77e4b5d99a'

  depends_on :jpeg

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --with-jpeg-include-dir=#{Jpeg.link_inc}
      --with-jpeg-lib-dir=#{Jpeg.link_lib}
      --without-x
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
