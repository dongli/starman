class FortranDatetime < Package
  url 'https://github.com/dongli/fortran-datetime/archive/v0.0.2.tar.gz'
  sha256 '4ecbfa4c77a453fdce68c6487fe786d65632de5b90b01773500a074a4ebdad6c'
  file_name 'fortran-datetime-0.0.2.tar.gz'

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
