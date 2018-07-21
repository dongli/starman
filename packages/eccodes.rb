class Eccodes < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.7.3-Source.tar.gz?api=v2'
  sha256 '6fab143dbb34604bb2e04d10143855c0906b00411c1713fd7ff5c35519b871db'

  depends_on :cmake
  depends_on :jasper
  depends_on :netcdf

  def install
    args = std_cmake_args
    args << '-DENABLE_JPG=On'
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DJASPER_PATH='#{link_inc}'"
    args << "-DNETCDF_PATH='#{link_inc}'"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
