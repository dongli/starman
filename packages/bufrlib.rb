class Bufrlib < Package
  url 'http://www.nco.ncep.noaa.gov/sib/decoders/BUFRLIB/BUFRLIB_v11-0-0.tar'
  sha256 'f8828216f1d523aae5cc34151153577dc8cead61b3df7b074f936776ec0069df'
  version '11.0.0'

  def install
    flags = CompilerSet.fortran.gcc? ? '-fno-second-underscore' : ''
    inreplace 'preproc.sh', {
      '-C' => '',
      'cpp' => 'cpp -traditional-cpp',
      '`ls *.F`' => '`ls ../*.F`',
      'bufrlib.PRM' => '../bufrlib.PRM'
    }
    # Since macOS isn't case-sensitive, we need to build in a new directory!
    mkdir 'build' do
      ln '../*.h', '.'
      ln '../*.c', '.'
      ln '../*.f', '.'
      run '$CC -c -DUNDERSCORE `../preproc.sh` *.c'
      run '$FC -c -DUNDERSCORE ', flags, ' modv*.f moda*.f `ls -1 *.f | grep -v "mod[av]_"`'
      run 'ar crv libbufr.a *.o'
    end
    mkdir inc
    mkdir lib
    mv '*.h', inc
    mv './build/libbufr.a', lib
  end
end
