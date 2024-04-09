class Jasper < Package
  url 'http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip'
  sha256 '6b905a9c2aca2e275544212666eefc4eb44d95d0a57e4305457b407fe63f9494'

  depends_on :jpeg

  def install
    inreplace 'src/libjasper/jpc/jpc_qmfb.c', {
      'int jpc_ft_synthesize(int *a' => 'int jpc_ft_synthesize(jpc_fix_t *a'
    }
    inreplace 'src/libjasper/jpc/jpc_qmfb.h', {
      'int (*analyze)(int *' => 'int (*analyze)(long *',
      'int (*synthesize)(int *' => 'int (*synthesize)(long *'
    }
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared
      --prefix=#{prefix}
      CFLAGS='-std=c90'
      CPPFLAGS='-I#{Jpeg.inc}'
      LDFLAGS='-L#{Jpeg.lib}'
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
