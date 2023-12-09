class SuiteSparse < Package
  url 'https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.1.0.tar.gz'
  sha256 '4cd3d161f9aa4f98ec5fa725ee5dc27bca960a3714a707a7d12b3d0abb504679'
  file_name 'SuiteSparse-7.1.0.tar.gz'

  depends_on :cmake
  depends_on :metis
  depends_on :openblas
  depends_on :mpfr

  def install
    args = %W[
      INSTALL=#{prefix}
      BLAS='-L#{Openblas.lib} -lopenblas'
      LAPACK='-L#{Openblas.lib} -lopenblas'
      MY_METIS_LIB='-L#{Metis.lib} -lmetis'
      MY_METIS_INC=#{Metis.inc}
      CMAKE_OPTIONS='#{std_cmake_args.join(' ')} -DMPFR_ROOT=#{Mpfr.prefix}'
      JOBS=#{jobs_number}
    ]
    run 'make', 'library', *args
    run 'make', 'install', *args
  end
end
