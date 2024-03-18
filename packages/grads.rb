class Grads < Package
  url 'http://cola.gmu.edu/grads/2.2/grads-2.2.1-src.tar.gz'
  sha256 '695e2066d7d131720d598bac0beb61ac3ae5578240a5437401dc0ffbbe516206'
  version '2.2.1'

  label :common

  depends_on :hdf5
  depends_on :netcdf
  depends_on :udunits
  depends_on :libgeotiff
  depends_on :libgd

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hdf5=#{Hdf5.link_root}
      --with-netcdf=#{Netcdf.link_root}
      --with-udunits=#{Udunits.link_root}
      --with-geotiff=#{Libgeotiff.link_root}
    ]
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
