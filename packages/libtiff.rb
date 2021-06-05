class Libtiff < Package
  url 'https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz'
  sha256 '0e46e5acb087ce7d1ac53cf4f56a09b221537fc86dfc5daaad1c2e89e1b37ac8'

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
