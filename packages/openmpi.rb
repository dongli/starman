class Openmpi < Package
  url 'https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.3.tar.bz2'
  sha256 '990582f206b3ab32e938aa31bbf07c639368e4405dca196fabe7f0f76eeda90b'

  label :mpi

  conflicts_with :mpich, :mvapich2

  option 'with-external-libs', 'Use STARMAN built libraries (libevent, hwloc, pmix, ucx).'

  depends_on :zlib
  if with_external_libs?
    depends_on :hwloc
    depends_on :pmix
    depends_on :libevent
    depends_on :ucx
  end

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
      --disable-sphinx
      --enable-shared
      --with-zlib=#{Zlib.prefix}
      --with-prrte=internal
    ]
    if with_external_libs?
      args << "--with-libevent=#{Libevent.prefix}"
      args << "--with-hwloc=#{Hwloc.prefix}"
      args << "--with-pmix=#{Pmix.prefix}"
      args << "--with-ucx=#{Ucx.prefix}"
    end
    ENV['lt_cv_ld_force_load'] = 'no' if OS.mac?
    run './configure', *args
    run 'make', 'all', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'check' if not skip_test?
    run 'make', 'install'
  end
end
