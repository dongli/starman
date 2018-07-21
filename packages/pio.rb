class Pio < Package
  url 'https://github.com/NCAR/ParallelIO/archive/pio2_3_1.tar.gz'
  sha256 'afe46cf97f73b518594e58d55684d5e423306686414b43fcc8c5c12d31a345f5'
  version '2.3.1'

  option 'with-pnetcdf', 'Use PnetCDF library.'

  depends_on :mpi
  depends_on :netcdf
  depends_on :pnetcdf if with_pnetcdf?

  def install
    ENV['CC'] = ENV['MPICC']
    ENV['FC'] = ENV['MPIFC']
    args = std_cmake_args
    args << "-DLIBZ_PATH=#{link_root}"
    args << "-DSZIP_PATH=#{link_root}"
    args << "-DHDF5_PATH=#{link_root}"
    args << "-DNetCDF_PATH=#{link_root}"
    if with_pnetcdf?
      args << "-DPnetCDF_PATH=#{link_root}"
    else
      args << "-DWITH_PNETCDF=OFF"
    end
    args << "-DMPIEXEC_PREFLAGS='--oversubscribe'"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
