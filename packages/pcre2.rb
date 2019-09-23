class Pcre2 < Package
  url 'https://ftp.pcre.org/pub/pcre/pcre2-10.33.tar.bz2'
  sha256 '35514dff0ccdf02b55bd2e9fa586a1b9d01f62332c3356e379eabb75f789d8aa'

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
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
