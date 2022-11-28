class Jpeg < Package
  url 'http://www.ijg.org/files/jpegsrc.v9d.tar.gz'
  sha256 '2303a6acfb6cc533e0e86e8a9d29f7e6079e118b9de3f96e07a71a11c082fa6a'
  version 'v9b'

  label :conflict_with_system if OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
