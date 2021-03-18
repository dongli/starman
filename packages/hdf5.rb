class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.bz2'
  sha256 '97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61'

  depends_on :szip
  depends_on :zlib
  depends_on :cmake
  depends_on :mpi

  option 'without-cxx', 'Disable C++ bindings.'
  option 'without-fortran', 'Disable Fortran bindings.'
  option 'enable-parallel', 'Enable parallel IO.'

  def install
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?

    args = std_cmake_args
    args << "-DHDF5_BUILD_CPP_LIB=#{(without_cxx? ? 'OFF' : 'ON')}"
    args << "-DHDF5_BUILD_FORTRAN=#{(without_fortran? ? 'OFF' : 'ON')}"
    if enable_parallel?
      args << '-DHDF5_ENABLE_PARALLEL=ON'
      args << '-DALLOW_UNSUPPORTED=ON'
      ENV['CC'] = ENV['MPICC']
      ENV['CXX'] = ENV['MPICXX']
      ENV['FC'] = ENV['MPIFC'] unless without_fortran?
    end

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
      args = multiple_jobs? ? '-j'+jobs_number : ''
      run 'make', *args
      run 'ctest', *args unless skip_test?
      run 'make', 'install', *args
    end
  end
end
