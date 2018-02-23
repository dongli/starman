class NetcdfFortran < Package
  url 'ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz'
  sha256 'b2d395175f8d283e68c8be516e231a96b191ade67ad0caafaf7fa01b1e6b5d75'

  grouped_by :netcdf

  depends_on 'netcdf-c'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-dap-remote-tests
      --enable-static
      --enable-shared
      CPPFLAGS='-I#{link_include}'
      LDFLAGS='-L#{link_lib}'
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
