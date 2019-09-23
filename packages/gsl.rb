class Gsl < Package
  url 'https://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz'
  mirror 'https://ftpmirror.gnu.org/gsl/gsl-2.6.tar.gz'
  sha256 'b782339fc7a38fe17689cb39966c4d821236c28018b6593ddb6fd59ee40786a8'

  def install
    run './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    run 'make'
    run 'make', 'install'
  end
end
