class Jasper < Package
  url 'http://download.osgeo.org/gdal/jasper-1.900.1.uuid.tar.gz'
  sha256 '0021684d909de1eb2f7f5a4d608af69000ce37773d51d1fb898e03b8d488087d'

  depends_on :jpeg

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared
      --prefix=#{prefix}
      CPPFLAGS='-I#{Jpeg.inc}'
      LDFLAGS='-L#{Jpeg.lib}'
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
