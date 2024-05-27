class Libaec < Package
  url 'https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.3/libaec-v1.1.3.tar.bz2'
  sha256 '46216f9d2f2d3ffea4c61c9198fe0236f7f316d702f49065c811447186d18222'
  version '1.1.3'

  def install
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args, '-DBUILD_TESTING=ON'
      run 'make'
      run 'make', 'test' unless skip_test?
      run 'make', 'install'
    end
  end
end
