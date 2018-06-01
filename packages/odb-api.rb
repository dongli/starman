class OdbApi < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/61117379/odb_api_bundle-0.17.6-Source.tar.gz'
  sha256 '6825de9a0d6cf540a8dcd6c79d2b0c95370866a21e53f242593c5c47cdb7198d'
  version '0.17.6'

  depends_on :eccodes
  depends_on :netcdf

  def install
    args = std_cmake_args
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DNETCDF_PATH='#{link_inc}'"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make', 'install'
    end
  end
end
