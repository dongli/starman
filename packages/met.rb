class Met < Package
  url 'https://dtcenter.org/sites/default/files/community-code/met/met-8.1.1.20190708.tar.gz'
  sha256 'b5b7e0f3c1d2b786f9ea625bce1fcd67d578dd1e73bd97825200e35428ecc745'
  version '8.1.1'

  label :common

  depends_on :bufrlib
  depends_on :g2clib
  depends_on :hdf4
  depends_on 'hdf-eos2', version: '2.19'
  depends_on 'netcdf-cxx4'
  depends_on :gsl
  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-grib2
      --disable-mode_graphics
      MET_NETCDF=#{NetcdfCxx4.link_root}
      MET_GRIB2C=#{G2clib.link_root}
      MET_GSL=#{Gsl.link_root}
      MET_BUFRLIB=#{Bufrlib.link_root}
      MET_HDF5=#{Hdf5.link_root}
      MET_HDF=#{Hdf4.link_root}
      MET_HDFEOS=#{HdfEos2.link_root}
      LDFLAGS='-L#{Netcdf.link_lib} #{OS.mac? ? "-L#{Libpng.lib}" : ''}'
    ]
    if OS.mac?
      inreplace 'src/basic/vx_config/config_util.cc', /(#include <sys\/types.h>)/, "\\1\n#include <sys/syslimits.h>\n"
    end
    run './configure', *args
    run 'make', 'install'
  end
end
