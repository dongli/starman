class Libaec < Package
  url 'https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.0.6/libaec-v1.0.6.tar.bz2'
  sha256 '31fb65b31e835e1a0f3b682d64920957b6e4407ee5bbf42ca49549438795a288'
  version '1.0.6'

  def install
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args, '-DBUILD_TESTING=ON'
      run 'make'
      run 'make', 'test' unless skip_test?
      run 'make', 'install'
    end
  end
end
