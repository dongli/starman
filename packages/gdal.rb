class Gdal < Package
  url 'https://github.com/OSGeo/gdal/releases/download/v3.0.1/gdal-3.0.1.tar.gz'
  sha256 '37fd5b61fabc12b4f13a556082c680025023f567459f7a02590600344078511c'

  label :common

  depends_on 'expat'
  depends_on 'geos'
  depends_on 'giflib'
  depends_on 'hdf5'
  depends_on 'jasper'
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
      --with-bsb
      --with-grib
      --with-pam
      --with-pcidsk=internal
      --with-pcraster=internal
      --with-expat=#{Expat.prefix}
      --with-geos=#{Geos.prefix}
      --with-geotiff=#{Libgeotiff.prefix}
      --with-gif=#{Giflib.prefix}
      --with-jpeg=#{Jpeg.prefix}
      --with-libjson-c=#{JsonC.prefix}
      --with-libtiff=#{Libtiff.prefix}
      --with-png=#{Libpng.prefix}
      --with-proj=#{Proj.prefix}
      --with-hdf5=#{Hdf5.prefix}
      --with-netcdf=#{Netcdf.prefix}
      --with-jasper=#{Jasper.prefix}
      --with-webp=#{Webp.prefix}
      --with-armadillo=no
      --with-qhull=no
      --without-grass
      --without-jpeg12
      --without-libgrass
      --without-mysql
      --without-perl
      --without-python
      --without-gta
      --without-ogdi
      --without-fme
      --without-hdf4
      --without-openjpeg
      --without-fgdb
      --without-ecw
      --without-kakadu
      --without-mrsid
      --without-jp2mrsid
      --without-mrsid_lidar
      --without-msg
      --without-oci
      --without-ingres
      --without-idb
      --without-sde
      --without-podofo
      --without-rasdaman
      --without-sosi
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
