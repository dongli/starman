class NetcdfFortran < Package
  url 'https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz'
  file_name 'netcdf-fortran-4.6.1.tar.gz'
  sha256 '40b534e0c81b853081c67ccde095367bd8a5eead2ee883431331674e7aa9509f'

  grouped_by :netcdf

  depends_on 'netcdf-c'

  option 'enable-parallel', 'Enable parallel IO.'

  def install
    ENV['CPPFLAGS'] += " -I#{link_inc}"
    ENV['LDFLAGS'] += " -L#{link_lib}"
    if OS.mac? and CompilerSet.fortran.intel?
      ENV['LDFLAGS'] += ' -Wl,-flat_namespace'
      ENV['FFLAGS'] = '-assume no2underscore'
    end
    ENV['FC'] = "#{enable_parallel? ? ENV['MPIFC'] : ENV['FC']} -fPIC"
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
