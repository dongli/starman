class NetcdfCxx4 < Package
  url 'https://github.com/Unidata/netcdf-cxx4/archive/v4.3.1.tar.gz'
  sha256 'e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc'
  version '4.3.1'
  file_name 'netcdf-cxx4-4.3.1.tar.gz'

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
