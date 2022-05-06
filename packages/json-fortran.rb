class JsonFortran < Package
  url 'https://github.com/jacobwilliams/json-fortran/archive/refs/tags/8.2.5.tar.gz'
  sha256 '16eec827f64340c226ba9a8463f001901d469bc400a1e88b849f258f9ef0d100'
  file_name 'json-fortran-8.2.5.tar.gz'

  depends_on :cmake

  option 'disable-unicode', 'Disable Unicode support so that CK=1'

  def install
    mkdir 'build' do
      args = %W[
        -DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE
        -DENABLE_UNICODE:BOOL=#{disable_unicode? ? 'FALSE' : 'TRUE'}
      ]
      run 'cmake', '..', *std_cmake_args, *args
      run 'make', 'install'
    end
  end
end
