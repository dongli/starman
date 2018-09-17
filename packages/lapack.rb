class Lapack < Package
  url 'https://www.netlib.org/lapack/lapack-3.8.0.tar.gz'
  sha256 'deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6'

  depends_on :cmake

  def install
    mkdir 'build' do
      run 'cmake', '..',
                   '-DBUILD_SHARED_LIBS:BOOL=ON',
                   '-DLAPACKE:BOOL=ON',
                   *std_cmake_args
      run 'make', 'install'
    end
  end
end
