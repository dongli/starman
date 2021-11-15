class NetcdfC < Package
  url 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz'
  sha256 '0e476f00aeed95af8771ff2727b7a15b2de353fb7bb3074a0d340b55c2bd4ea8'

  grouped_by :netcdf

  depends_on :m4
  depends_on :hdf5
  depends_on :mpi

  option 'disable-netcdf-4', 'Disable NetCDF4 interfaces.'
  option 'enable-parallel', 'Enable parallel IO.'

  def install
    # Fix a bug for PGI compiler.
    inreplace 'nc_test4/test_filter_misc.c', '#define DBLVAL 12345678.12345678d', '#define DBLVAL 12345678.12345678'
    inreplace 'nc_test4/tst_filterparser.c', '#define DBLVAL 12345678.12345678d', '#define DBLVAL 12345678.12345678'
    ENV['CPPFLAGS'] += " -I#{link_inc} -DNDEBUG"
    ENV['LDFLAGS'] += " -L#{link_lib} -lsz"
    ENV['CC'] = ENV['MPICC'] if enable_parallel?
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
    args << '--enable-parallel-tests' if enable_parallel?
    ENV['lt_cv_ld_force_load'] = 'no' if OS.mac?
    run './configure', *args
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'check' if not skip_test? and not CompilerSet.c.intel?
    run 'make', 'install'
  end
end
