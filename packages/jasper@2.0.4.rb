class Jasper < Package
  url 'https://codeload.github.com/mdadams/jasper/tar.gz/version-2.0.14'
  sha256 '85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b'
  file_name 'jasper-2.0.14.tar.gz'

  depends_on :cmake
  depends_on :jpeg

  option 'disable-opengl', 'Disable OpenGL dependencies.'

  def install
    args = std_cmake_args
    args << '-DJAS_ENABLE_OPENGL=Off' if disable_opengl?
    args << '-DJAS_ENABLE_DOC=Off'
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      # FIXME: Some tests need openjpeg.
      #run 'make', 'test' unless skip_test?
      run 'make', 'install'
    end
  end
end
