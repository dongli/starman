class Magics < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/3473464/Magics-3.1.0-Source.tar.gz?api=v2'
  sha256 'c5c1cf1d1c06982927a40b61245b656ea8cadabe00201418bc69ccbe4156d658'

  label :common

  depends_on :cmake
  depends_on :proj
  depends_on :netcdf
  depends_on :eccodes
  depends_on :emoslib
  depends_on 'odb-api'

  option 'enable-python', 'Enable Python interface.'

  def install
    args = std_cmake_args
    args << '-DENABLE_METVIEW=On'
    args << '-DENABLE_NETCDF=On'
    args << "-DNETCDF_PATH=#{Netcdf.link_root}"
    args << '-DENABLE_GRIB=On'
    args << '-DENABLE_ECCODES=On'
    args << "-DECCODES_PATH=#{Eccodes.link_root}"
    args << '-DENABLE_BUFR=On'
    args << "-DEMOS_PATH=#{Emoslib.link_root}"
    args << '-DENABLE_ODB=On'
    args << "-DODB_API_PATH=#{OdbApi.link_root}"
    args << "-DPROJ4_PATH=#{Proj.link_root}"
    args << "-DENABLE_PYTHON=#{enable_python? ? 'On' : 'Off'}"
    args << "-DCMAKE_PREFIX_PATH=/usr/local/Cellar/qt/5.11.1" if OS.mac?
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'MAGPLUS=$(PWD)/..', 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
