class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.0.tar.bz2'
  sha256 '9d845ca94bc1aeb445f83d98d238cd08f6ec7ad0f73b0f79ec1668dbfdacd613'

  label :mpi

  conflicts_with :mpich, :mvapich2

  option 'with-ucx', 'Use UCX library.'
  option 'with-verbs', 'Use VERBS library.'

  depends_on :zlib

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
      --with-libevent=internal
      --with-pmix=internal
      --with-prrte=internal
      --with-hwloc=internal
      --with-zlib=#{Zlib.prefix}
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
