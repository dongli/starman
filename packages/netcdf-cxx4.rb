class NetcdfCxx4 < Package
  url 'https://github.com/Unidata/netcdf-cxx4/archive/v4.3.0.tar.gz'
  sha256 '25da1c97d7a01bc4cee34121c32909872edd38404589c0427fefa1301743f18f'
  version '4.3.0'
  file_name 'netcdf-cxx4-4.3.0.tar.gz'

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
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
