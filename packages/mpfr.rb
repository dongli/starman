class Mpfr < Package
  url 'http://mirrors.aliyun.com/gnu/mpfr/mpfr-4.2.0.tar.xz'
  sha256 '06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993'

  depends_on :gmp

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-gmp=#{Gmp.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
