class NetcdfC < Package
  url 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz'
  sha256 '5c537c585773e575a16b28c3973b9608a98fdc4cf7c42893aa5223024e0001fc'

  grouped_by :netcdf

  depends_on :m4
  depends_on :hdf5

  option 'disable-netcdf-4', 'Disable NetCDF4 interfaces.'

  def install
    # Fix a bug for PGI compiler.
    inreplace 'nc_test4/test_filter_misc.c', '#define DBLVAL 12345678.12345678d', '#define DBLVAL 12345678.12345678'
    inreplace 'nc_test4/tst_filterparser.c', '#define DBLVAL 12345678.12345678d', '#define DBLVAL 12345678.12345678'
    if CompilerSet.c.pgi?
      ENV['CPPFLAGS'] += ' -DNDEBUG'
      ENV['LDFLAGS'] = '-lsz'
    end
    ENV['CPPFLAGS'] += " -I#{link_inc}"
    ENV['LDFLAGS'] += " -L#{link_lib}"
  	args = %W[
      --prefix=#{prefix}
      --enable-utilities
      --enable-shared
      --enable-static
      --disable-dap-remote-tests
      --disable-doxygen
      --disable-dap
    ]
    args << '--disable-netcdf-4' if disable_netcdf_4?
    run './configure', *args
    run 'make'
    run 'make', 'check' if not skip_test? and not CompilerSet.c.intel?
    run 'make', 'install'
  end
end
