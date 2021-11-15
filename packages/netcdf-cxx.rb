class NetcdfCxx < Package
  url 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx-4.2.tar.gz'
  sha256 '95ed6ab49a0ee001255eac4e44aacb5ca4ea96ba850c08337a3e4c9a0872ccd1'

  grouped_by :netcdf

  depends_on 'netcdf-c'

  def install
    return false if CompilerSet.cxx.pgi? and OS.mac?
    ENV['CPPFLAGS'] += " -I#{link_inc}"
    ENV['LDFLAGS'] += " -L#{link_lib}"
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-dap-remote-tests
      --enable-static
      --enable-shared
    ]
    run './configure', *args
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
