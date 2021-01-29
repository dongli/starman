class Udunits < Package
  url 'https://artifacts.unidata.ucar.edu/repository/downloads-udunits/udunits-2.2.28-Source.tar.gz'
  sha256 '4cff332db4368c621998116603ad2d35cfd4a605e60a77e9a7270aed7d905711'
  version '2.2.28'

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
