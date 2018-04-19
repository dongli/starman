class Udunits < Package
  url 'ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.25.tar.gz'
  sha256 'ad486f8f45cba915ac74a38dd15f96a661a1803287373639c17e5a9b59bfd540'

  label :common

  depends_on :expat

  def install
    args = %W[
      --prefix=#{prefix}
      CPPFLAGS='-I#{link_inc}'
      LDFLAGS='-L#{link_lib}'
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
