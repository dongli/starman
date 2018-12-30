class Pio < Package
  url 'https://github.com/NCAR/ParallelIO/archive/pio2_3_1.tar.gz'
  sha256 'afe46cf97f73b518594e58d55684d5e423306686414b43fcc8c5c12d31a345f5'
  version '2.3.1'

  option 'with-pnetcdf', 'Use PnetCDF library.'

  depends_on :mpi
  depends_on :cmake
  depends_on :netcdf
  depends_on :pnetcdf if with_pnetcdf?

  resource :cmake_fortran_utils do
    url 'https://codeload.github.com/CESM-Development/CMake_Fortran_utils/zip/1f03f20'
    sha256 'e7cdd875ffcdd67cdf590c97c0dff2c8cc57b0890ac3bc18ab3189baf3637ae0'
    file_name 'CMake_Fortran_utils-1f03f20.zip'
  end

  resource :genf90 do
    url 'https://github.com/PARALLELIO/genf90/archive/genf90_140121.zip'
    sha256 '474a2b3746c9ad1f51a099ad954530751d292771b134ababa16dba54a67ff3b9'
  end

  def install
    ENV['CC'] = ENV['MPICC']
    ENV['FC'] = ENV['MPIFC']
    install_resource :cmake_fortran_utils, '.'
    install_resource :genf90, '.'
    args = std_cmake_args
    args << "-DLIBZ_PATH=#{link_root}"
    args << "-DSZIP_PATH=#{link_root}"
    args << "-DHDF5_PATH=#{link_root}"
    args << "-DNetCDF_PATH=#{link_root}"
    args << "-DUSER_CMAKE_MODULE_PATH=#{pwd}/cmake_fortran_utils"
    args << "-DGENF90_PATH=#{pwd}/genf90"
    if with_pnetcdf?
      args << "-DPnetCDF_PATH=#{link_root}"
    else
      args << "-DWITH_PNETCDF=OFF"
    end
    args << "-DMPIEXEC_PREFLAGS='--oversubscribe'" if MPI.openmpi?
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
