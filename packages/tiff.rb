class Tiff < Package
  url 'https://gitlab.com/libtiff/libtiff/repository/Release-v4-0-9/archive.tar.bz2'
  sha256 '4a149164b00985773e4305a891828202e991b03d917a77162592b875031d5b80'
  file_name 'tiff-4.0.9.tar.bz2'

  label :skip_if_exist, file: '/System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/libTIFF.dylib' if OS.mac?

  depends_on :jpeg

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --without-x
      --with-jpeg-include-dir=#{include}
      --with-jpeg-lib-dir=#{lib}
      --disable-lzma
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
