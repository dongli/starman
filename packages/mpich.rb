class Mpich < Package
  url 'https://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz'
  sha256 '5db53bf2edfaa2238eb6a0a5bc3d2c2ccbfbb1badd79b664a1a919d2ce2330f1'

  label :mpi

  conflicts_with :openmpi, :mvapich2

  option 'enable-fast', 'Get fastest performance at the expense of error reporting and other program development aids.'

  def export_env
    ENV['MPICC'] = "#{bin}/mpicc"
    ENV['MPICXX'] = "#{bin}/mpic++"
    ENV['MPIFC'] = "#{bin}/mpifort"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    args << '--enable-fast=all,O3' if enable_fast?
    run './configure', *args
    run 'make'
    run 'make', 'check' unless skip_test?
    run 'make', 'install'
  end
end
