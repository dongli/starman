class Openarray < Package
  url 'https://github.com/hxmhuang/OpenArray/archive/1.0.1.tar.gz'
  sha256 '3a21246ab9ca2e569304437fe05f504bb2778fbd1ed8a43a61692a0c0be6150e'
  file_name 'openarray-1.0.1.tar.gz'

  depends_on :pnetcdf
  depends_on :mpi

  def install
    args = %W[
      --prefix=#{prefix}
      PNETCDF_DIR=#{Pnetcdf.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'test' unless skip_test?
    run 'make', 'install'
  end
end
