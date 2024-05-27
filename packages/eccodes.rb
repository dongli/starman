class Eccodes < Package
  url 'https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.34.1-Source.tar.gz'
  sha256 'f9b8680122e3ccec26e6ed24a81f1bc50ed9f2232b431e05e573678aac4d9734'

  depends_on :cmake
  depends_on :libaec
  depends_on :libpng
  depends_on :netcdf
  depends_on :openjpeg

  option 'with-python3', 'Build Python 3 bindings.'

  def export_env
    if Dir.exist? lib + '/python*'
      append_env 'PYTHONPATH', "#{Dir.glob(lib + '/python*').first}/site-packages"
    end
  end

  def install
    args = std_cmake_args search_paths: [link_root]
    args << '-DENABLE_FORTRAN=On'
    args << '-DENABLE_NETCDF=On'
    args << "-DNETCDF_PATH='#{link_root}'"
    args << '-DENABLE_JPG=On'
    args << "-DOPENJPEG_PATH='#{link_root}'"
    args << '-DENABLE_JPG_LIBOPENJPEG=ON'
    args << '-DENABLE_JPG_LIBJASPER=OFF'
    args << '-DENABLE_ECCODES_THREADS=ON'
    if with_python3?
      args << "-DENABLE_PYTHON=On"
      args << "-DPYTHON_EXECUTABLE=#{which 'python3'}"
      CLI.warning "Ignore #{CLI.red '--with-python2'} option." if with_python2?
    else
      args << "-DENABLE_PYTHON=Off"
    end
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
      run 'ctest' unless skip_test?
      run 'make', 'install'
    end
  end
end
