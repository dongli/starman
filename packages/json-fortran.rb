class JsonFortran < Package
  url 'https://github.com/jacobwilliams/json-fortran/archive/7.1.0.tar.gz'
  sha256 'e7aa1f6e09b25ebacb17188147380c3f8c0a254754cd24869c001745fcecc9e6'
  file_name 'json-fortran-7.1.0.tar.gz'

  depends_on :cmake

  def install
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args,
                         '-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE',
                         '-DENABLE_UNICODE:BOOL=TRUE'
      run 'make', 'install'
    end
  end
end
