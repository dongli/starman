class Met < Package
  url 'https://github.com/dtcenter/MET/releases/download/v10.1.2/met-10.1.2.20220516.tar.gz'
  sha256 'f0ef0de116495c91128ca6a267bb4f93088220f33d4b9d2cf57f014be6fd9742'
  version '10.1.2'

  label :common

  option 'with-sat', 'Enable functionality for satellite'

  depends_on :nceplibs
  depends_on :bufrlib
  depends_on :hdf4 if with_sat?
  depends_on 'hdf-eos2' if with_sat?
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
      MET_GRIB2C=#{Nceplibs.prefix}/g2c-1.6.2
      GRIB2CLIB_NAME=-lg2c
      MET_GSL=#{Gsl.link_root}
      MET_BUFRLIB=#{Bufrlib.link_root}
      MET_HDF5=#{Hdf5.link_root}
      LDFLAGS='-L#{Netcdf.link_lib} #{OS.mac? ? "-L#{Libpng.lib}" : ''}'
      CPPFLAGS='-D__64BIT__'
    ]
    if with_sat?
      args << "MET_HDF=#{Hdf4.link_root}"
      args << "MET_HDFEOS=#{HdfEos2.link_root}"
    end
    if OS.mac?
      inreplace 'src/basic/vx_config/config_util.cc', /(#include <sys\/types.h>)/, "\\1\n#include <sys/syslimits.h>\n"
    end
    run './configure', *args
    run 'make', 'install', multiple_jobs? ? "-j#{jobs_number}" : ''
  end
end
