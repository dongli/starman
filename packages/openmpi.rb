class Openmpi < Package
  url 'https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.0.tar.bz2'
  sha256 'f699bff21db0125d8cccfe79518b77641cd83628725a1e1ed3e45633496a82d7'

  label :mpi

  conflicts_with :mpich, :mvapich2

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-debug
      --enable-shared
      --with-verbs
      --with-hwloc=internal
      --without-ucx
    ]
    # FIXME: Check if we need to add MXM and KNEM explicitly, or do they affect performance.
    args << '--with-mxm=/opt/mellanox/mxm' if File.directory? '/opt/mellanox/mxm'
    dir = `find /opt -maxdepth 1 -type d -name "knem*" -print0`.strip
    args << "--with-knem=#{dir}" if dir and File.directory? dir
    run './configure', *args
    run 'make', 'all', '-j', '8'
    run 'make', 'check' if not skip_test?
    run 'make', 'install'
  end
end
