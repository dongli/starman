class Blosc < Package
  url 'https://github.com/Blosc/c-blosc/archive/v1.21.1.tar.gz'
  sha256 'f387149eab24efa01c308e4cba0f59f64ccae57292ec9c794002232f7903b55b'
  file_name 'blosc-1.21.1.tar.gz'

  depends_on :cmake

  def install
    run 'cmake', '.', *std_cmake_args
    run 'make', 'install'
  end
end
