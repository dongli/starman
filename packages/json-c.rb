class JsonC < Package
  url 'https://github.com/json-c/json-c/archive/json-c-0.13.1-20180305.tar.gz'
  sha256 '5d867baeb7f540abe8f3265ac18ed7a24f91fe3c5f4fd99ac3caba0708511b90'
  version '0.13.1'

  depends_on :cmake

  def install
    args = std_cmake_args
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'install'
    end
    cp 'json_object_iterator.h', inc + '/json-c'
  end
end
