class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.bz2'
  sha256 '73866fb77090819b6a8c85cb8539638d37d6877455825b74e289d647a39fd5b5'

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
