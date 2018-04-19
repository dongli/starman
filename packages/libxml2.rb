class Libxml2 < Package
  url 'http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz'
  sha256 'f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c'

  label :common

  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --without-python
      --without-lzma
      --with-zlib=#{Zlib.prefix}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end