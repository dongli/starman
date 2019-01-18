class HdfEos2 < Package
  url 'ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos/latest_release/HDF-EOS2.19v1.00.tar.Z'
  sha256 '3fffa081466e85d2b9436d984bc44fe97bbb33ad9d8b7055a322095dc4672e31'
  version '2.19'

  depends_on :hdf4
  depends_on :jpeg
  depends_on :szip
  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hdf4=#{link_root}
      --with-zlib=#{link_root}
      --with-szlib=#{link_root}
      CC='#{link_bin}/h4cc -Df2cFortran'
    ]
    args << "--with-jpeg=#{OS.mac? ? Jpeg.prefix : link_root}"
    run './configure', *args
    run 'make'
    run 'make', 'install'
    work_in 'include' do
      run 'make', 'install'
    end
  end
end
