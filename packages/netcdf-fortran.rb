class NetcdfFortran < Package
  url 'https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz'
  file_name 'netcdf-fortran-4.5.3.tar.gz'
  sha256 'c6da30c2fe7e4e614c1dff4124e857afbd45355c6798353eccfa60c0702b495a'

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
