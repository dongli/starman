class Sqlite3 < Package
  url 'https://sqlite.org/2019/sqlite-autoconf-3290000.tar.gz'
  sha256 '8e7c1e2950b5b04c5944a981cb31fffbf9d2ddda939d536838ebc854481afd5b'
  version ' 3.29.0'

  label :common
  label :skip_if_exist, library_file: "libsqlite3.#{OS.soname}"

  depends_on :readline

  def install
    append_env 'CPPFLAGS', '-DSQLITE_ENABLE_COLUMN_METADATA=1', sep=' '
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    append_env 'CPPFLAGS', '-DSQLITE_MAX_VARIABLE_NUMBER=250000', sep=' '
    append_env 'CPPFLAGS', '-DSQLITE_ENABLE_RTREE=1', sep=' '
    append_env 'CPPFLAGS', '-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1', sep=' '
    append_env 'CPPFLAGS', '-DSQLITE_ENABLE_JSON1=1', sep=' '
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
