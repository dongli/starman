class Proj < Package
  url 'https://download.osgeo.org/proj/proj-6.2.0.tar.gz'
  sha256 'b300c0f872f632ad7f8eb60725edbf14f0f8f52db740a3ab23e7b94f1cd22a50'

  label :common

  depends_on :sqlite3

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]
    args << "SQLITE3_LIBS=#{Sqlite3.lib}/libsqlite3.#{OS.soname}" unless Sqlite3.skipped?
    run './configure', *args
    run 'make', 'install'
  end
end
