class Gdal < Package
  url 'http://download.osgeo.org/gdal/3.5.3/gdal-3.5.3.tar.xz'
  sha256 'd32223ddf145aafbbaec5ccfa5dbc164147fb3348a3413057f9b1600bb5b3890'

  label :common

  depends_on 'expat'
  depends_on 'geos'
  depends_on 'giflib'
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'json-c'
  depends_on 'libgeotiff'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'libxml2'
  depends_on 'netcdf'
  depends_on 'pcre2'
  depends_on 'proj'
  depends_on 'webp'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --with-libtool
      --with-local=#{prefix}
      --without-opencl
      --with-threads
      --with-pam
      --with-pcidsk=internal
      --with-pcraster=internal
      --with-expat=#{Expat.prefix}
      --with-geos=#{Geos.bin}/geos-config
      --with-geotiff=#{Libgeotiff.prefix}
      --with-gif=#{Giflib.prefix}
      --with-jpeg=#{Jpeg.prefix}
      --with-libjson-c=#{JsonC.prefix}
      --with-libtiff=#{Libtiff.prefix}
      --with-png=#{Libpng.prefix}
      --with-proj=#{Proj.prefix}
      --with-hdf5=#{Hdf5.prefix}
      --with-netcdf=#{Netcdf.prefix}
      --with-webp=#{Webp.prefix}
      --with-armadillo=no
      --with-qhull=no
      --without-jpeg12
      --without-mysql
      --without-python
      --without-gta
      --without-ogdi
      --without-hdf4
      --without-openjpeg
      --without-fgdb
      --without-ecw
      --without-kakadu
      --without-mrsid
      --without-jp2mrsid
      --without-msg
      --without-oci
      --without-idb
      --without-podofo
      --without-rasdaman
      --without-sosi
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
