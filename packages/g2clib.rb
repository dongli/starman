class G2clib < Package
  url 'http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2clib-1.6.0.tar'
  sha256 'afec1ea29979b84369d0f46f305ed12f73f1450ec2db737664ec7f75c1163add'

  depends_on :jasper
  depends_on :libpng
  depends_on :zlib

  def install
    inreplace 'makefile', {
      'INC=-I/nwprod/lib/include/' => "INC=-I#{link_inc} -I#{Libpng.inc}",
      'CC=gcc' => "CC=#{CompilerSet.c.command}"
    }
    run 'make'
    mkdir inc
    cp 'grib2.h', inc
    mkdir lib
    cp 'libg2c_v1.6.0.a', lib
    cp 'libg2c_v1.6.0.a', lib + '/libgrib2c.a'
  end
end
