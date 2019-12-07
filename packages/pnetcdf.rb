class Pnetcdf < Package
  url 'https://github.com/Parallel-NetCDF/PnetCDF/archive/checkpoint.1.12.0.tar.gz'
  sha256 '12e491aac4059e6129dad8620600f487834cc5779509c6ce7c4eba21b254a5b3'
  file_name 'pnetcdf-1.12.0.tar.gz'

  option 'without-cxx', 'Disable C++ bindings'
  option 'without-fortran', 'Disable Fortran bindings'

  depends_on :mpi

  def install
    run 'autoreconf', '-i'
    args = %W[
      --prefix=#{prefix}
      CC=#{ENV['MPICC']}  
      CXX=#{ENV['MPICXX']}
      FC=#{ENV['MPIFC']}
    ]
    args << '--disable-cxx' if without_cxx?
    args << '--disable-fortran' if without_fortran?
    # Script configure will reset them to blank somehow, so hardcode them!
    inreplace './configure', {
      /(if test "x\$\{MPICC\}" = x ; then)/ => "MPICC=#{ENV['MPICC']}\n\\1",
      /(if test "x\$\{MPICXX\}" = x ; then)/ => "MPICXX=#{ENV['MPICXX']}\n\\1",
      /(if test "x\$\{MPIF90\}" = x ; then)/ => "MPIF90=#{ENV['MPIFC']}\n\\1",
      /(if test "x\$\{MPIF77\}" = x ; then)/ => "MPIF77=#{ENV['MPIFC']}\n\\1"
    }
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
