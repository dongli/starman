class Proj < Package
  url 'https://download.osgeo.org/proj/proj-6.3.1.tar.gz'
  sha256 '6de0112778438dcae30fcc6942dee472ce31399b9e5a2b67e8642529868c86f8'

  label :common

  depends_on :sqlite3

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]
    if not Sqlite3.skipped?
      args << "SQLITE3_CFLAGS='-I#{Sqlite3.inc}'"
      args << "SQLITE3_LIBS='-L#{Sqlite3.lib} -lsqlite3'"
    end
    run './configure', *args
    run 'make', 'install'
  end
end
