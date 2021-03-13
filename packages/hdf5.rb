class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.bz2'
  sha256 '97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61'

  depends_on :szip
  depends_on :zlib
  depends_on :mpi

  option 'with-cxx', 'Enable C++ bindings.'
  option 'without-fortran', 'Disable Fortran bindings.'
  option 'enable-parallel', 'Enable parallel IO.'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-build-mode=production
      --disable-dependency-tracking
      --with-zlib=#{install_root}
      --with-szlib=#{install_root}
      --enable-static=yes
      --enable-shared=yes
      --enable-threadsafe
      --enable-unsupported
    ]
    if enable_parallel?
      args << '--enable-parallel'
      ENV['CC'] = ENV['MPICC']
      ENV['CXX'] = ENV['MPICXX']
      ENV['FC'] = ENV['MPIFC'] unless without_fortran?
    end
    ENV['CPPFLAGS'] = '-no-multibyte-chars' if CompilerSet.c.intel?
    args << with_cxx? ? '--enable-cxx' : '--disable-cxx'
    args << '--enable-fortran' unless without_fortran?
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?
    run './configure', *args
    args = multiple_jobs? ? '-j'+jobs_number : ''
    run 'make', *args
    run 'make', 'check', *args unless skip_test?
    run 'make', 'install', *args
  end
end
