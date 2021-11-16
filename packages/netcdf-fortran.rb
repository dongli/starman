class NetcdfFortran < Package
  url 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz'
  sha256 '123a5c6184336891e62cf2936b9f2d1c54e8dee299cfd9d2c1a1eb05dd668a74'

  grouped_by :netcdf

  depends_on 'netcdf-c'

  def install
    ENV['CPPFLAGS'] += " -I#{link_inc}"
    ENV['LDFLAGS'] += " -L#{link_lib}"
    if OS.mac? and CompilerSet.fortran.intel?
      ENV['LDFLAGS'] += ' -Wl,-flat_namespace'
      ENV['FFLAGS'] = '-assume no2underscore'
    end
    ENV['FC'] = "#{CompilerSet.fortran.command} -fPIC"
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-dap-remote-tests
      --enable-static
      --enable-shared
    ]
    ENV['lt_cv_ld_force_load'] = 'no' if OS.mac?
    run './configure', *args
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
