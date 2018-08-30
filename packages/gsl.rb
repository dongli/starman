class Gsl < Package
  url 'https://ftp.gnu.org/gnu/gsl/gsl-2.5.tar.gz'
  mirror 'https://ftpmirror.gnu.org/gsl/gsl-2.5.tar.gz'
  sha256 '0460ad7c2542caaddc6729762952d345374784100223995eb14d614861f2258d'

  def install
    run './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'install'
  end
end
