module Utils
  def set_compile_env
    # FIXME: Only a package depends on mpi should set CC to MPICC.
    ENV['CC'] = mpi_c_compiler || c_compiler
    ENV['CXX'] = mpi_cxx_compiler || cxx_compiler
    ENV['FC'] = mpi_fortran_compiler || fortran_compiler
    ENV['F77'] = mpi_fortran_compiler || fortran_compiler
    ENV['MPICC'] = mpi_c_compiler
    ENV['MPICXX'] = mpi_cxx_compiler
    ENV['MPIFC'] = mpi_fortran_compiler
    ENV['MPIF77'] = mpi_fortran_compiler
    ENV['MPIF90'] = mpi_fortran_compiler
  end
end
