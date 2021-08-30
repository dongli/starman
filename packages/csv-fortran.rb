class CsvFortran < Package
  url 'https://github.com/jacobwilliams/fortran-csv-module/archive/refs/tags/1.3.1.zip'
  sha256 '3b379adb7fe52a6680302f4a91ca328ae6260bb4590c1da54afe6983cda452f9'
  file_name 'csv-fortran-1.3.1.zip'

  depends_on :cmake

  def install
    args = std_cmake_args

    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'install'
    end

    # Remove or rename directories.
    work_in prefix do
      rm 'bin'
      rm 'files'
      rm 'doc'
      mv 'finclude', 'include'
    end
  end
end
