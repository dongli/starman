class Openjpeg < Package
  url 'https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz'
  sha256 '3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a'
  file_name 'openjpeg-2.3.0.tar.gz'

  depends_on :cmake

  def install
    args = std_cmake_args
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'install'
    end
  end
end
