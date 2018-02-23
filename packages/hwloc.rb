class Hwloc < Package
  url 'https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.0.tar.bz2'
  sha256 '99e56f72d21f4e9c449b57f602ef72d79bf0a2e2ff5fb77367fd1a9f5c312708'

  label :common

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --without-x
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
