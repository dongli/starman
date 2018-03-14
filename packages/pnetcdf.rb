class Pnetcdf < Package
  url 'http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-1.9.0.tar.gz'
  sha256 '356e1e1fae14bc6c4236ec11435cfea0ff6bde2591531a4a329f9508a01fbe98'

  option 'without-cxx', 'Disable C++ bindings'
  option 'without-fortran', 'Disable Fortran bindings'

  depends_on :mpi

  def install
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
