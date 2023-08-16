class Pnetcdf < Package
  url 'https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz'
  sha256 '439e359d09bb93d0e58a6e3f928f39c2eae965b6c97f64e67cd42220d6034f77'

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
