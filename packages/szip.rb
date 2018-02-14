class Szip < Package
  url 'https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz'
  sha256 '21ee958b4f2d4be2c9cabfa5e1a94877043609ce86fde5f286f105f7ff84d412'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    run './configure', *args
    run 'make', 'install'
  end
end
