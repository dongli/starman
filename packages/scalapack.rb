class Scalapack < Package
  url 'https://netlib.org/scalapack/scalapack-2.2.0.tgz'
  sha256 '40b9406c20735a9a3009d863318cb8d3e496fb073d201c5463df810e01ab2a57'

  depends_on :cmake
  depends_on :mpi
  depends_on :openblas

  def install
    inreplace 'CMakeLists.txt', {
      'target_link_libraries( scalapack ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})' =>
      'target_link_libraries( scalapack ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${MPI_Fortran_LIBRARIES})'
    }
    inreplace 'CMakeLists.txt', 16, <<-EOS
   if ("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "GNU")
      set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fallow-argument-mismatch" )
   endif ()
EOS
    mkdir 'build' do
      blas = "'-L#{Openblas.lib} -lopenblas'"
      run 'cmake', '..', *std_cmake_args, '-DBUILD_SHARED_LIBS=ON',
                   "-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"
      run 'make', 'all'
      run 'make', 'install'
    end
  end
end
