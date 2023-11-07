class Cdo < Package
  url 'https://code.mpimet.mpg.de/attachments/download/28882/cdo-2.2.2.tar.gz'
  sha256 '419c77315244019af41a296c05066f474cccbf94debfaae9e2106da51bc7c937'

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
    # inreplace 'test/Makefile', 'CDO = $(top_builddir)/src/cdo' => 'CDO = $(top_builddir)/src/cdo -L'
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
