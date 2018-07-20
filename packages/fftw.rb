class Fftw < Package
  url 'http://www.fftw.org/fftw-3.3.8.tar.gz'
  sha256 '6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303'

  option 'with-openmp', 'Use OpenMP compiler directives in order to induce parallelism.'
  option 'with-mpi', 'Enable compilation and installation of the FFTW MPI library.'

  depends_on :mpi if with_mpi?

  def install
    args = %W[
      --prefix=#{prefix}
    ]
    args << '--enable-openmp' if with_openmp?
    args << '--enable-mpi' if with_mpi?
    run './configure', *args
    run 'make'
    run 'make', 'check'
    run 'make', 'install'
  end
end
