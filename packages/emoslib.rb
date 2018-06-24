class Emoslib < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/3473472/libemos-4.5.5-Source.tar.gz?api=v2'
  sha256 '88e3ca91268df5ae2db1909460445ed43e95de035d62b02cab26ce159851a4c1'

  depends_on :eccodes

  def install
    args = std_cmake_args
    args << "-DECCODES_PATH=#{Eccodes.link_root}"
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'test' unless skip_test?
      run 'make', 'install'
    end
  end
end
