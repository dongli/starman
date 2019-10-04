class Libgeotiff < Package
  url 'https://github.com/OSGeo/libgeotiff/releases/download/1.5.1/libgeotiff-1.5.1.tar.gz'
  sha256 'f9e99733c170d11052f562bcd2c7cb4de53ed405f7acdde4f16195cd3ead612c'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'proj'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --with-jpeg=#{Jpeg.link_root}
      --with-libtiff=#{Libtiff.link_root}
      --with-proj=#{Proj.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
