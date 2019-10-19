class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.bz2'
  sha256 '68d6ea8843d2a106ec6a7828564c1689c7a85714a35d8efafa2fee20ca366f44'

  depends_on :szip
  depends_on :zlib

  option 'with-cxx', 'Build C++ bindings.'
  option 'without-fortran', 'Do not build Fortran bindings.'
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
    args << '--enable-fortran' unless without_fortran?
    args << '--enable-threadsafe --enable-unsupported' if enable_threadsafe?
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
