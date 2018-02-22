class Jasper < Package
  url 'https://codeload.github.com/mdadams/jasper/tar.gz/version-2.0.14'
  sha256 '85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b'
  file_name 'jasper-2.0.14.tar.gz'

  depends_on :jpeg

  def install
    mkdir 'build' do
      run 'cmake', '..', *std_cmake_args
      run 'make'
      run 'make', 'test'
      run 'make', 'install'
    end
  end
end
