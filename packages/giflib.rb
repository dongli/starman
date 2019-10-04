class Giflib < Package
  url 'https://downloads.sourceforge.net/project/giflib/giflib-5.1.4.tar.bz2'
  sha256 'df27ec3ff24671f80b29e6ab1c4971059c14ac3db95406884fc26574631ba8d5'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
