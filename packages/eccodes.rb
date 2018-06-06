class Eccodes < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.7.0-Source.tar.gz?api=v2'
  sha256 '118f46cf6f800585580a5bc838128537ab0879073e9fcded49cd374e4c8d8e6a'

  depends_on :cmake
  depends_on :jasper
  depends_on :netcdf

  def install
    args = std_cmake_args
    args << '-DENABLE_JPG=On'
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DNETCDF_PATH='#{link_inc}'"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'ctest' unless skip_test?
      run 'make', 'install'
    end
  end
end
