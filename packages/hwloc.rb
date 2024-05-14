class Hwloc < Package
  url 'https://download.open-mpi.org/release/hwloc/v2.10/hwloc-2.10.0.tar.bz2'
  sha256 '0305dd60c9de2fbe6519fe2a4e8fdc6d3db8de574a0ca7812b92e80c05ae1392'

  label :common

  option 'without-rocm', 'Build without ROCM.'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --without-x
    ]
    args << '--without-rocm' if without_rocm?
    run './configure', *args
    run 'make', 'install'
  end
end
