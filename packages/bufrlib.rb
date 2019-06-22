class Bufrlib < Package
  url 'https://www.emc.ncep.noaa.gov/BUFRLIB/docs/BUFRLIB_v11-3-0.tar'
  sha256 '122bc2accfca5a572eaf26e2267d1d40efe1d8d60907a1b99c921f875757e94a'
  version '11.3.0'

  def install
    flags = CompilerSet.fortran.gcc? ? '-fno-second-underscore' : ''
    run '$CC -DUNDERSCORE -c `./getdefflags_C.sh` *.c'
    run '$FC -c `./getdefflags_F.sh` modv*.F moda*.F `ls -1 *.F *.f | grep -v "mod[av]_"`', flags
    run 'ar crv libbufr.a *.o'
    mkdir inc
    mkdir lib
    mv '*.h', inc
    mv 'libbufr.a', lib
  end
end
