class Sqlite3 < Package
  url 'https://sqlite.org/2020/sqlite-autoconf-3310100.tar.gz'
  sha256 '62284efebc05a76f909c580ffa5c008a7d22a1287285d68b7825a2b6b51949ae'
  version ' 3.31.1'

  label :common
  label :alone
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
