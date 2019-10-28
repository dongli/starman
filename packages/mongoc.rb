class Mongoc < Package
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/1.15.1/mongo-c-driver-1.15.1.tar.gz'
  sha256 '4ee47c146ff0059d15ab547a0c2a87f7113f063e1c625e51f8c5174853b07765'

  label :common

  depends_on :cmake

  def install
    run 'cmake', '.', *std_cmake_args
    run 'make', 'install'
    if Dir.exist? lib64
      ['libbson-1.0.pc', 'libbson-static-1.0.pc', 'libmongoc-1.0.pc', 'libmongoc-static-1.0.pc'].each do |pc|
        inreplace lib64 + '/pkgconfig/' + pc, {
          '${prefix}/lib' => '${prefix}/lib64'
        }
      end
    end
  end
end
