class Jpeg < Package
  url 'http://www.ijg.org/files/jpegsrc.v9b.tar.gz'
  sha256 '240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052'
  version 'v9b'

  label :skip_if_exist, file: '/System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libJPEG.dylib' if OS.mac?

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
