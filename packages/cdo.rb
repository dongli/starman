class Cdo < Package
  url 'https://code.mpimet.mpg.de/attachments/download/27654/cdo-2.1.1.tar.gz'
  sha256 'c29d084ccbda931d71198409fb2d14f99930db6e7a3654b3c0243ceb304755d9'

  label :common

  depends_on :eccodes
  depends_on :hdf5
  depends_on :libxml2
  depends_on :netcdf
  depends_on :jasper
  depends_on :proj
  depends_on :udunits

  def install
    ENV['LDFLAGS'] = "-L#{Eccodes.lib64}"
    if Hdf5.enable_parallel?
      ENV['CC'] = ENV['MPICC']
      ENV['CXX'] = ENV['MPICXX']
      ENV['FC'] = ENV['MPIFC']
    end
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
      LIBS='-lz'
    ]
    run './configure', *args
    inreplace 'test/Makefile', 'CDO = $(top_builddir)/src/cdo' => 'CDO = $(top_builddir)/src/cdo -L'
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
