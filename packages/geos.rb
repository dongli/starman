class Geos < Package
  url 'https://download.osgeo.org/geos/geos-3.7.1.tar.bz2'
  sha256 '0006c7b49eaed016b9c5c6f872417a7d7dc022e069ddd683335793d905a8228c'

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace 'configure', {
      /PYTHON_CPPFLAGS=.*/ => %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}"),
      /PYTHON_LDFLAGS=.*/ => 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    }

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    run './configure', *args
    run 'make', 'install'
  end
end
