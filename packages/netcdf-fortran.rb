class NetcdfFortran < Package
  url 'ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.5.2.tar.gz'
  sha256 'b959937d7d9045184e9d2040a915d94a7f4d0185f4a9dceb8f08c94b0c3304aa'

  grouped_by :netcdf

  depends_on 'netcdf-c'

  def install
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
    args = multiple_jobs? ? '-j'+jobs_number : ''
    run 'make', *args
    run 'make', 'check', *args unless skip_test?
    run 'make', 'install', *args
  end
end
