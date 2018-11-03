class Gdbm < Package
  url 'https://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz'
  mirror 'https://ftpmirror.gnu.org/gdbm/gdbm-1.18.1.tar.gz'
  sha256 '86e613527e5dba544e73208f42b78b7c022d4fa5a6d5498bf18c8d6f745b91dc'

  label :common

  option 'with-libgdbm-compat', 'Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces.'

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    # Use --without-readline because readline detection is broken in 1.13
    # https://github.com/Homebrew/homebrew-core/pull/10903
    args << '--without-readline' if OS.mac?

    args << '--enable-libgdbm-compat' if with_libgdbm_compat?

    run './configure', *args
    run 'make', 'install'
  end
end

