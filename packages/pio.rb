class Pio < Package
  url 'https://github.com/NCAR/ParallelIO/archive/refs/tags/pio2_5_10.zip'
  sha256 '6c5d7369922422541f43e089802eb6e3e4b83569bb7c23c09ca040036eeb7947'
  version '2.5.10'
  file_name 'ParallelIO-pio2_5_10.zip'

  option 'with-pnetcdf', 'Use PnetCDF library.'

  depends_on :mpi
  depends_on :cmake
  depends_on :netcdf
  depends_on :pnetcdf if with_pnetcdf?

  resource :cmake_fortran_utils do
    url 'https://github.com/CESM-Development/CMake_Fortran_utils/archive/refs/tags/CMake_Fortran_utils_150308.tar.gz'
    sha256 '4f22073e0142494c421a21a059a861f55965ed6e730fd186ef25302a75e6cfb8'
  end

  resource :genf90 do
    url 'https://github.com/PARALLELIO/genf90/archive/refs/tags/genf90_200608.zip'
    sha256 'db269c0cde55fab83d1da26cdf2b81fe27905540a660b4c78bfa39159dc2e397'
  end

  def install
    ENV['CC'] = ENV['MPICC']
    ENV['CXX'] = ENV['MPICXX']
    ENV['FC'] = ENV['MPIFC']
    install_resource :genf90, '.'
    args = std_cmake_args
    args << "-DLIBZ_PATH=#{link_root}"
    args << "-DSZIP_PATH=#{link_root}"
    args << "-DHDF5_PATH=#{link_root}"
    args << "-DNetCDF_C_PATH=#{link_root}"
    args << "-DNetCDF_Fortran_PATH=#{link_root}"
    args << "-DUSER_CMAKE_MODULE_PATH=#{pwd}/cmake_fortran_utils"
    args << "-DGENF90_PATH=#{pwd}/genf90"
    args << "-DPIO_ENABLE_TIMING=OFF"
    if with_pnetcdf?
      args << "-DPnetCDF_PATH=#{link_root}"
    else
      args << "-DWITH_PNETCDF=OFF"
    end
    if skip_test?
      args << "-DPIO_ENABLE_TESTS=OFF"
    end
    args << "-DMPIEXEC_PREFLAGS='--oversubscribe'" if MPI.openmpi?
    mkdir 'build' do
      install_resource :cmake_fortran_utils, '.'
      run 'cmake', '..', *args
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
      run 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
