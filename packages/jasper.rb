class Jasper < Package
  url 'http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip'
  sha256 '6b905a9c2aca2e275544212666eefc4eb44d95d0a57e4305457b407fe63f9494'

  depends_on :jpeg

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared
      --prefix=#{prefix}
      CPPFLAGS='-I#{Jpeg.inc}'
      LDFLAGS='-L#{Jpeg.lib}'
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
