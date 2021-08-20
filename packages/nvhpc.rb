class Nvhpc < Package
  if OS.linux?
    url 'https://developer.download.nvidia.com/hpc-sdk/nvhpc_2020_207_Linux_x86_64_cuda_11.0.tar.gz'
    sha256 'ec5a385650194b4213bce53f3766089656916e28e38df3aa3882ff35667b0be2'
  end
  version '20.7'

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
  end

  def export_env
    append_path bin
    append_path mpi_bin
    append_manpath "#{root}/compilers/man"
    append_manpath "#{root}/comm_libs/mpi/share/man"
  end
end
