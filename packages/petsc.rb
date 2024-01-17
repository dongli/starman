class Petsc < Package
  url 'https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.2.tar.gz'
  sha256 '2a2d08b5f0e3d0198dae2c42ce1fd036f25c153ef2bb4a2d320ca141ac7cd30b'

  depends_on :mpi
  depends_on :hdf5
  depends_on :netcdf
  depends_on :metis
  depends_on :openblas
  depends_on :scalapack
  depends_on 'suite-sparse'

  def install
    ENV.delete 'PETSC_DIR'
    args = %W[
      --prefix=#{prefix}
      --with-debugging=0
      --with-scalar-type=real
      --with-x=0
    ]
    run './configure', *args
    run 'make', 'all'
    run 'make', 'install'
  end
end
