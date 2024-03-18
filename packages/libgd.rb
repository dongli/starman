class Libgd < Package
  url 'https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz'
  sha256 '3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61'

  depends_on :zlib
  depends_on :libpng
  depends_on :jpeg
  depends_on :libtiff

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=#{Zlib.link_root}
      --with-png=#{Libpng.link_root}
      --with-jpeg=#{Jpeg.link_root}
      --with-tiff=#{Libtiff.link_root}
      --with-x
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
