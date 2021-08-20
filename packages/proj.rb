class Proj < Package
  url 'https://download.osgeo.org/proj/proj-7.2.1.tar.gz'
  sha256 'b384f42e5fb9c6d01fe5fa4d31da2e91329668863a684f97be5d4760dbbf0a14'

  label :common

  depends_on :sqlite3
  depends_on :libtiff

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      TIFF_CFLAGS='-I#{Libtiff.inc}'
      TIFF_LIBS='-L#{Libtiff.lib} -ltiff'
    ]
    if not Sqlite3.skipped?
      args << "SQLITE3_CFLAGS='-I#{Sqlite3.inc}'"
      args << "SQLITE3_LIBS='-L#{Sqlite3.lib} -lsqlite3'"
    end
    run './configure', *args
    run 'make', 'install'
  end
end
