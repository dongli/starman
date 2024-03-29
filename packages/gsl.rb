class Gsl < Package
  url 'https://mirrors.sjtug.sjtu.edu.cn/gnu/gsl/gsl-2.7.tar.gz'
  sha256 ''

  def install
    run './configure', '--disable-dependency-tracking', "--prefix=#{prefix}"
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'install'
  end
end
