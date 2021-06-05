class Mongoc < Package
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/1.17.5/mongo-c-driver-1.17.5.tar.gz'
  sha256 '4b15b7e73a8b0621493e4368dc2de8a74af381823ae8f391da3d75d227ba16be'

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
