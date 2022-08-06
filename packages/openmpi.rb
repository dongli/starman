class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2'
  sha256 '92912e175fd1234368c8730c03f4996fe5942e7479bb1d10059405e7f2b3930d'

  label :mpi

  conflicts_with :mpich, :mvapich2

  option 'with-ucx', 'Use UCX library.'
  option 'with-verbs', 'Use VERBS library.'

  def export_env
    ENV['MPICC'] = "#{bin}/mpicc"
    ENV['MPICXX'] = "#{bin}/mpic++"
    ENV['MPIFC'] = "#{bin}/mpifort"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-debug
      --enable-shared
      --with-hwloc=internal
    ]
    args << '--with-ucx' if with_ucx?
    args << '--with-verbs' if with_verbs?
    ENV['lt_cv_ld_force_load'] = 'no' if OS.mac?
    run './configure', *args
    run 'make', 'all', '-j', '8'
    run 'make', 'check' if not skip_test?
    run 'make', 'install'
  end
end
