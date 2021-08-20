class Jpeg < Package
  url 'http://www.ijg.org/files/jpegsrc.v9d.tar.gz'
  sha256 '6c434a3be59f8f62425b2e3c077e785c9ce30ee5874ea1c270e843f273ba71ee'
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
