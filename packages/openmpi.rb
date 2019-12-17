class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.bz2'
  sha256 '900bf751be72eccf06de9d186f7b1c4b5c2fa9fa66458e53b77778dffdfe4057'

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
