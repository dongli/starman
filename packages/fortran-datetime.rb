class FortranDatetime < Package
  url 'https://github.com/dongli/fortran-datetime/archive/v0.0.3.tar.gz'
  sha256 'f69662e5bdbea9c1c279bdc9c28251fd513a64296725341f9278b6862b95e063'
  file_name 'fortran-datetime-0.0.3.tar.gz'

  label :common

  depends_on :cmake

  def install
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args
      run 'make'
      run 'make', 'install'
    end
  end
end
