class Libtiff < Package
  url 'https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz'
  sha256 '2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4'

  depends_on 'jpeg'

  patch strip: 1 do
    url 'https://raw.githubusercontent.com/Homebrew/formula-patches/d15e00544e7df009b5ad34f3b65351fc249092c0/libtiff/libtiff-CVE-2019-6128.patch'
    sha256 'dbec51f5bec722905288871e3d8aa3c41059a1ba322c1ac42ddc8d62646abc66'
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --with-jpeg-include-dir=#{Jpeg.link_inc}
      --with-jpeg-lib-dir=#{Jpeg.link_lib}
      --without-x
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
