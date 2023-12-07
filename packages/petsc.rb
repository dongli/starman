class Petsc < Package
  url 'https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.1.tar.gz'
  sha256 '3d54f13000c9c8ceb13ca4f24f93d838319019d29e6de5244551a3ec22704f32'

  depends_on :hdf5
  depends_on :netcdf
  depends_on :metis
  depends_on :openblas
  depends_on :scalapack
  depends_on :suite_sparse
end
