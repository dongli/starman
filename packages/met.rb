class Met < Package
  url 'https://dtcenter.org/met/users/downloads/MET_releases/met-8.0.20180927.tar.gz'
  sha256 '3d1674d7d6f63590caed9dc8a16e51e36ab7e0cefaa0abee0626013462970ba2'
  version '8.0'

  label :common

  depends_on :bufrlib
  depends_on :g2clib
  depends_on :hdf4
  depends_on :hdf_eos2
  depends_on :netcdf
  depends_on :gsl
  depends_on :zlib

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-grib2
      --disable-mode_graphics
      MET_NETCDF=#{Netcdf.link_root}
      MET_GRIB2C=#{G2clib.link_root}
      MET_GSL=#{Gsl.link_root}
      MET_BUFRLIB=#{Bufrlib.link_root}
      MET_HDF5=#{Hdf5.link_root}
      MET_HDF=#{Hdf4.link_root}
      MET_HDFEOS=#{Hdf_eos2.link_root}
      LDFLAGS='-L#{Netcdf.link_lib} #{OS.mac? ? "-L#{Libpng.lib}" : ''}'
    ]
    if OS.mac?
      inreplace 'src/basic/vx_config/config_util.cc', /(#include <sys\/types.h>)/, "\\1\n#include <sys/syslimits.h>\n"
    end
    run './configure', *args
    run 'make', 'install'
  end
end
