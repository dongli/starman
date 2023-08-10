class Nvhpc < Package
  if OS.linux?
    url 'https://developer.download.nvidia.com/hpc-sdk/23.7/nvhpc_2023_237_Linux_x86_64_cuda_12.2.tar.gz'
    sha256 '5606fc0c282c345d8039cd44b552e609da1147043857fe232c10d31846a4e64d'
  end
  version '23.7'

  label :compiler
  label :mpi
  label :alone

  def root
    "#{prefix}/#{`uname -s`.chomp}_#{`uname -m`.chomp}/#{version}"
  end

  def bin
    "#{root}/compilers/bin"
  end

  def mpi_bin
    "#{root}/comm_libs/mpi/bin"
  end

  def lib
    "#{root}/compilers/lib"
  end

  def mpi_lib
    "#{root}/comm_libs/mpi/lib"
  end

  def install
    ENV['NVHPC_SILENT'] = 'true'
    ENV['NVHPC_INSTALL_DIR'] = prefix
    ENV['NVPHC_INSTALL_TYPE'] = 'single'
    run './install'
  end

  def post_install
    # Update conf file to add this new compiler set.
    Settings.settings['compiler_sets']["nvhpc_#{version}"] = {
      'c' => "#{bin}/nvcc",
      'mpi_c' => "#{mpi_bin}/mpicc",
      'cxx' => "#{bin}/nvc++",
      'mpi_cxx' => "#{mpi_bin}/mpic++",
      'fortran' => "#{bin}/nvfortran",
      'mpi_fortran' => "#{mpi_bin}/mpif90"
    }
    Settings.write
    CLI.caveat <<-EOS
Please add the following lines into your ~/.bashrc:
export NVARCH=`uname -s`_`uname -m`
export NVCOMPILERS=#{prefix}
export MANPATH=$MANPATH:$NVCOMPILERS/$NVARCH/23.7/compilers/man
export PATH=$NVCOMPILERS/$NVARCH/23.7/compilers/bin:$PATH
export PATH=$NVCOMPILERS/$NVARCH/23.7/comm_libs/mpi/bin:$PATH
export MANPATH=$MANPATH:$NVCOMPILERS/$NVARCH/23.7/comm_libs/mpi/man
EOS
  end

  def export_env
    append_path bin
    append_path mpi_bin
    append_manpath "#{root}/compilers/man"
    append_manpath "#{root}/comm_libs/mpi/share/man"
  end
end
