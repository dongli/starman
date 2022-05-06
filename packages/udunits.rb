class Udunits < Package
  url 'https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz'
  sha256 '590baec83161a3fd62c00efa66f6113cec8a7c461e3f61a5182167e0cc5d579e'

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
