class Hdf4 < Package
  url 'https://support.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.13.tar.bz2'
  sha256 '55d3a42313bda0aba7b0463687caf819a970e0ba206f5ed2c23724f80d2ae0f3'

  depends_on :yacc
  depends_on :flex
  depends_on :jpeg
  depends_on :szip
  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=#{link_root}
      --with-szlib=#{link_root}
      --disable-netcdf
      --enable-fortran
      --enable-static
    ]
    args << "--with-jpeg=#{OS.mac? ? Jpeg.prefix : link_root}"
    args << '--disable-fortran' unless CompilerSet.fortran
    run './configure', *args
    run 'make', 'install'
  end

  def post_install
    mv bin + '/ncdump', bin + '/ncdump_hdf4'
    mv bin + '/ncgen', bin + '/ncgen_hdf4'
  end
end
