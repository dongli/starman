class Pcre2 < Package
  url 'https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.bz2'
  sha256 '14e4b83c4783933dc17e964318e6324f7cae1bc75d8f3c79bc6969f00c159d68'

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
