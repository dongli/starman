class Eccodes < Package
  url 'https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.9.0-Source.tar.gz?api=v2'
  sha256 'ff04eb1fa4c363438bbbd6d75b66b4237c7397f8b0bd311d9243b6b2dcfc09d6'

  depends_on :cmake
  depends_on :openjpeg
  depends_on :jasper
  depends_on :netcdf

  option 'with-python2', 'Build Python2 bindings.'

  def install
    args = std_cmake_args search_paths: [link_root]
    args << '-DENABLE_JPG=On'
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DJASPER_PATH='#{link_inc}'"
    args << "-DNETCDF_PATH='#{link_inc}'"
    args << "-DENABLE_PYTHON=#{with_python2? ? 'On' : 'Off'}"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
