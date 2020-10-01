class Jpeg < Package
  url 'http://www.ijg.org/files/jpegsrc.v9d.tar.gz'
  sha256 '650250979303a649e21f87b5ccd02672af1ea6954b911342ea491f351ceb7122'
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
