class Cdo < Package
  url 'https://code.mpimet.mpg.de/attachments/download/20124/cdo-1.9.7.1.tar.gz'
  sha256 '3771952e065bcf935d43e492707370ed2a0ecb59a06bea24f9ab69d77943962c'

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
    inreplace 'test/tsformat.test', 'test -n "$CDO"      || CDO=cdo', 'CDO="../src/cdo -L"'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
