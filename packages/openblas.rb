class Openblas < Package
  url 'https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.24.tar.gz'
  sha256 'ceadc5065da97bd92404cac7254da66cc6eb192679cf1002098688978d4d5132'
  file_name 'openblas-0.3.24.tar.gz'

  def install
    ENV['DYNAMIC_ARCH'] = '1'
    ENV['USE_OPENMP'] = '1'
    ENV['NUM_THREADS'] = '56'
    run 'make', "CC=#{ENV['CC']}", "FC=#{ENV['FC']}", 'libs', 'netlib', 'shared'
    run 'make', "PREFIX=#{prefix}", 'install'
  end
end
