class Pcre2 < Package
  url 'https://ftp.pcre.org/pub/pcre/pcre2-10.33.tar.bz2'
  sha256 '35514dff0ccdf02b55bd2e9fa586a1b9d01f62332c3356e379eabb75f789d8aa'

  depends_on :zlib
  depends_on :bzip2

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]
    append_env 'CPPFLAGS', "-I#{Zlib.link_inc}", sep=' '
    append_env 'LDFLAGS', "-L#{Zlib.link_lib}", sep=' '
    unless Bzip2.skipped?
      append_env 'CPPFLAGS', "-I#{Bzip2.link_inc}", sep=' '
      append_env 'LDFLAGS', "-L#{Bzip2.link_lib}", sep=' '
    end
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
