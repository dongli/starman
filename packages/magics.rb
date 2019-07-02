class Magics < Package
  url 'https://confluence.ecmwf.int/download/attachments/3473464/Magics-4.0.2-Source.tar.gz'
  sha256 '2cf7bfdaac4b6921a86d1090bf61258862d5ff47ee8770a42af3436820ea7868'

  label :common

  depends_on :cmake
  depends_on :proj
  depends_on :netcdf
  depends_on :eccodes
  depends_on :emoslib
  depends_on 'odb-api'

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
    args << "-DPYTHON_EXECUTABLE=$(which python3)"
    # FIXME: We assume user installed Qt by using Homebrew.
    if OS.mac?
      CLI.error 'Install libffi first!' if not Dir.exist? '/usr/local/opt/libffi/lib/pkgconfig'
      ENV['PKG_CONFIG_PATH'] = '/usr/local/opt/libffi/lib/pkgconfig'
      CLI.error 'Install qt first!' if not Dir.exist? '/usr/local/Cellar/qt'
      args << "-DCMAKE_PREFIX_PATH=#{Dir.glob('/usr/local/Cellar/qt/*').first}"
      inreplace 'src/terralib/kernel/TeUtils.cpp', '#include <sys/sysctl.h>', "#define _Atomic volatile\n#include <sys/sysctl.h>"
    end
    ['tools/xml2cc_mv.py', 'tools/xml2cc.py'].each do |file|
      inreplace file, '#!/usr/bin/env python', '#!/usr/bin/env python3'
    end
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'MAGPLUS=$(pwd)/..', 'make', 'check' unless skip_test?
      run 'make', 'install'
    end
  end
end
