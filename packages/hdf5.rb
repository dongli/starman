class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.3/src/hdf5-1.14.3.tar.bz2'
  sha256 '9425f224ed75d1280bb46d6f26923dd938f9040e7eaebf57e66ec7357c08f917'

  depends_on :szip
  depends_on :zlib
  depends_on :cmake
  depends_on :mpi

  option 'without-cxx', 'Disable C++ bindings.'
  option 'without-fortran', 'Disable Fortran bindings.'
  option 'enable-parallel', 'Enable parallel IO.'

  def install
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?
    ENV['CFLAGS'] = '-fPIC'

    args = std_cmake_args
    args << "-DHDF5_BUILD_CPP_LIB=#{(without_cxx? ? 'OFF' : 'ON')}"
    args << "-DHDF5_BUILD_FORTRAN=#{(without_fortran? ? 'OFF' : 'ON')}"
    if enable_parallel?
      args << '-DHDF5_ENABLE_PARALLEL=ON'
      args << '-DALLOW_UNSUPPORTED=ON'
    end
    args << '-DHDF5_ENABLE_THREADSAFE=OFF'

    args << "-DZLIB_DIR=#{install_root}"
    args << "-DSZIP_DIR=#{install_root}"
    args << '-DHDF5_ENABLE_Z_LIB_SUPPORT=ON'
    args << '-DHDF5_ENABLE_SZIP_SUPPORT=ON'

    if OS.mac?
      # Shared fortran is not supported, build static (according to release_docs/INSTALL_CMake.txt)
      args << '-DBUILD_SHARED_LIBS=OFF'
    end

    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
      run 'ctest' unless skip_test?
      run 'make', 'install'
    end
  end
end
