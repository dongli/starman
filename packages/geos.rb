class Geos < Package
  url 'https://download.osgeo.org/geos/geos-3.7.2.tar.bz2'
  sha256 '2166e65be6d612317115bfec07827c11b403c3f303e0a7420a2106bc999d7707'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-python
    ]

    run './configure', *args
    run 'make', 'install'
  end
end
