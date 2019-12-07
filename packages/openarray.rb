class Openarray < Package
  url 'https://github.com/hxmhuang/OpenArray/archive/1.0.1.tar.gz'
  sha256 ''
  version '1.0.1'

  depends_on :pnetcdf
  depends_on :mpi

  def install
    args = %W[
      --prefix=#{prefix}
      PNETCDF_DIR=#{Pnetcdf.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
