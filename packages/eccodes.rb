class Eccodes < Package
  url 'https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.27.0-Source.tar.gz'
  sha256 'ede5b3ffd503967a5eac89100e8ead5e16a881b7585d02f033584ed0c4269c99'

  depends_on :cmake
  depends_on :openjpeg
  depends_on :jasper
  depends_on :netcdf
  depends_on :libaec

  option 'with-python2', 'Build Python 2 bindings.'
  option 'with-python3', 'Build Python 3 bindings.'

  def export_env
    if Dir.exist? lib + '/python*'
      append_env 'PYTHONPATH', "#{Dir.glob(lib + '/python*').first}/site-packages"
    end
  end

  def install
    inreplace 'cmake/FindOpenJPEG.cmake', {
      'include/openjpeg-2.1 )' => "include/openjpeg-2.1 include/openjpeg-#{Openjpeg.version.major_minor} )"
    }
    inreplace 'cmake/ecbuild_check_os.cmake', {
      '-Wl,--allow-shlib-undefined' => ''
    }
    args = std_cmake_args search_paths: [link_root]
    args << '-DENABLE_JPG=On'
    args << '-DENABLE_NETCDF=On'
    args << '-DENABLE_FORTRAN=On'
    args << "-DOPENJPEG_PATH='#{link_root}'"
    args << "-DJASPER_PATH='#{link_root}'"
    args << "-DNETCDF_PATH='#{link_root}'"
    if with_python3?
      args << "-DENABLE_PYTHON=On"
      args << "-DPYTHON_EXECUTABLE=#{which 'python3'}"
      CLI.warning "Ignore #{CLI.red '--with-python2'} option." if with_python2?
    elsif with_python2?
      args << "-DENABLE_PYTHON=On"
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
