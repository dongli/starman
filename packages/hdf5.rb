class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.bz2'
  sha256 '9c5ce1e33d2463fb1a42dd04daacbc22104e57676e2204e3d66b1ef54b88ebf2'

  depends_on :szip
  depends_on :zlib

  option 'with-cxx', 'Build C++ bindings.'
  option 'with-fortran', 'Build Fortran bindings.'
  option 'enable-threadsafe', 'Enable thread safe.'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-build-mode=production
      --disable-dependency-tracking
      --with-zlib=#{install_root}
      --with-szlib=#{install_root}
      --enable-static=yes
      --enable-shared=yes
    ]
    args << with_cxx? ? '--enable-cxx' : '--disable-cxx'
    args << '--enable-fortran' if with_fortran?
    args << '--enable-threadsafe --enable-unsupported' if enable_threadsafe?
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
