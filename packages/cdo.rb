class Cdo < Package
  url 'https://code.mpimet.mpg.de/attachments/download/23323/cdo-1.9.9.tar.gz'
  sha256 '959b5b58f495d521a7fd1daa84644888ec87d6a0df43f22ad950d17aee5ba98d'

  label :common

  depends_on :eccodes
  depends_on :hdf5
  depends_on :libxml2
  depends_on :netcdf
  depends_on :jasper
  depends_on :proj
  depends_on :udunits

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hdf5=#{Hdf5.prefix}
      --with-netcdf=#{Netcdf.prefix}
      --with-zlib=#{Zlib.prefix}
      --with-szlib=#{Szip.prefix}
      --with-jasper=#{Jasper.prefix}
      --with-eccodes=#{Eccodes.prefix}
      --with-udunits2=#{Udunits.prefix}
      --with-proj=#{Proj.prefix}
      --with-libxml2=#{Libxml2.prefix}
      --disable-dependency-tracking
      --disable-debug
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
