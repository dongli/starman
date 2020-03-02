class Hdf5 < Package
  url 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.6/src/hdf5-1.10.6.tar.bz2'
  sha256 '09d6301901685201bb272a73e21c98f2bf7e044765107200b01089104a47c3bd'

  depends_on :szip
  depends_on :zlib

  option 'with-cxx', 'Build C++ bindings.'
  option 'with-fortran', 'Do not build Fortran bindings.'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-build-mode=production
      --disable-dependency-tracking
      --with-zlib=#{install_root}
      --with-szlib=#{install_root}
      --enable-static=yes
      --enable-shared=yes
      --enable-threadsafe
      --enable-unsupported
    ]
    args << with_cxx? ? '--enable-cxx' : '--disable-cxx'
    args << '--enable-fortran' if with_fortran?
    ENV['LDFLAGS'] = '' if CompilerSet.c.pgi?
    run './configure', *args
    args = multiple_jobs? ? '-j'+jobs_number : ''
    run 'make', *args
    run 'make', 'check', *args unless skip_test?
    run 'make', 'install', *args
  end
end
