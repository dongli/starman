class Proj < Package
  url 'https://github.com/OSGeo/proj.4/releases/download/5.0.1/proj-5.0.1.tar.gz'
  sha256 'a792f78897482ed2c4e2af4e8a1a02e294c64e32b591a635c5294cb9d49fdc8c'

  label :common

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
