class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.bz2'
  sha256 'c654ed847f34a278c52a15c98add40402b4a90f0c540779f1ae6c489af8a76c5'

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
    run './configure', *args
    run 'make', 'all', '-j', '8'
    run 'make', 'check' if not skip_test?
    run 'make', 'install'
  end
end
