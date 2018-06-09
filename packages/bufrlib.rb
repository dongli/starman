class Bufrlib < Package
  url 'http://www.nco.ncep.noaa.gov/sib/decoders/BUFRLIB/BUFRLIB_v11-0-0.tar'
  sha256 'f8828216f1d523aae5cc34151153577dc8cead61b3df7b074f936776ec0069df'
  version '11.0.0'

  def install
    if CompilerSet.fortran.gcc?
      flags = '-fno-underscoring'
    else
      flags = ''
    end
    inreplace 'preproc.sh', {
      '*.F' => '../*.F',
      'bufrlib.PRM' => '../bufrlib.PRM'
    }
    if CompilerSet.fortran.intel?
      inreplace 'preproc.sh', 'cpp', 'fpp'
    end
    mkdir 'build' do
      ln '../*.f', '.'
      ln '../*.c', '.'
      ln '../*.h', '.'
      run '$CC -c `../preproc.sh` *.c'
      run '$FC ', flags, ' -c modv*.f moda*.f `ls -1 *.f | grep -v "mod[av]_"`'
      run 'ar crv libbufr.a *.o'
    end
    mkdir inc
    mkdir lib
    mv '*.h', inc
    mv './build/libbufr.a', lib
  end
end
