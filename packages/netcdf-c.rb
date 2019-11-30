class NetcdfC < Package
  url 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.2.tar.gz'
  sha256 'b751cc1f314ac8357df2e0a1bacf35a624df26fe90981d3ad3fa85a5bbd8989a'

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
    args = multiple_jobs? ? '-j'+jobs_number : ''
    run 'make', *args
    run 'make', 'check', *args if not skip_test? and not CompilerSet.c.intel?
    run 'make', 'install', *args
  end
end
