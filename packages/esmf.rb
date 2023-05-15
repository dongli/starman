class Esmf < Package
  url 'https://github.com/esmf-org/esmf/archive/refs/tags/v8.3.1.tar.gz'
  sha256 '6c39261e55dcdf9781cdfa344417b9606f7f961889d5ec626150f992f04f146d'
  version '8.3.1'

  option 'use-mkl', 'Use MKL for LAPACK dependency.'
  option 'use-pnetcdf', 'Use Parallel-NetCDF dependency.'
  option 'mpi-type', 'Set MPI type.', type: :string, choices: ['mpich', 'mpich2', 'mpich3', 'lam', 'openmpi', 'intelmpi']
  option 'with-esmpy', 'Install ESMPy interface.'

  if use_mkl?
    CLI.notice 'Use MKL for LAPACK.'
  else
    depends_on :lapack
  end
  depends_on :mpi
  depends_on :netcdf
  depends_on :pnetcdf if use_pnetcdf?

  def export_env
    append_env 'PYTHONPATH', "#{lib}/python3.6/site-packages" if Dir.exist? "#{lib}/python3.6/site-packages"
  end

  def install
    ENV['ESMF_DIR'] = pwd
    ENV['ESMF_BOPT'] = 'O'
    ENV['ESMF_OPTLEVEL'] = '2'
    if CompilerSet.c.vendor == :gcc and CompilerSet.fortran.vendor == :gcc
      CLI.error "ESMF needs gfortran with version >= 4.3!" if CompilerSet.fortran.version <= '4.3'
      ENV['ESMF_COMPILER'] = 'gfortran'
    elsif CompilerSet.c.vendor == :gcc and CompilerSet.fortran.vendor == :intel
      ENV['ESMF_COMPILER'] = 'intelgcc'
    elsif CompilerSet.c.vendor == :intel and CompilerSet.fortran.vendor == :intel
      ENV['ESMF_COMPILER'] = 'intel'
    else
      CLI.error "Unsupported compiler set!"
    end
    ENV['ESMF_INSTALL_PREFIX'] = prefix
    ENV['ESMF_INSTALL_BINDIR'] = bin
    ENV['ESMF_INSTALL_HEADERDIR'] = inc
    ENV['ESMF_INSTALL_LIBDIR'] = lib
    ENV['ESMF_INSTALL_MODDIR'] = inc
    if use_mkl?
      ENV['ESMF_LAPACK'] = 'mkl'
    else
      ENV['ESMF_LAPACK'] = 'system'
      ENV['ESMF_LAPACK_LIBPATH'] = Dir.exist?(Lapack.link_lib64) ? Lapack.link_lib64 : Lapack.link_lib
      ENV['ESMF_LAPACK_LIBS'] = '-llapack -lblas'
    end
    ENV['ESMF_NETCDF'] = 'nc-config'
    ENV['ESMF_PNETCDF'] = 'pnetcdf-config' if use_pnetcdf?
    ENV['ESMF_PIO'] = 'internal'
    if mpi_type
      ENV['ESMF_COMM'] = mpi_type.to_s
    elsif ENV['MPICXX'] =~ /mpiicpc$/ or ENV['MPIFC'] =~ /mpiifort$/
      ENV['ESMF_COMM'] = 'intelmpi'
    else
      CLI.error "You should set #{CLI.blue '--mpi-type'} option!"
    end
    inreplace 'build_config/Linux.gfortran.default/ESMC_Conf.h', {
      'typedef size_t ESMCI_FortranStrLenArg;' => "#include <stddef.h>\ntypedef size_t ESMCI_FortranStrLenArg;"
    }
    run 'make', multiple_jobs? ? "-j#{jobs_number}" : ''
    run 'make', 'unit_tests' if not skip_test?
    run 'make', 'install'

    if with_esmpy?
      work_in 'src/addon/ESMPy' do
        ENV['ESMFMKFILE'] = "#{lib}/esmf.mk"
        run 'python3', 'setup.py', 'build', "--ESMFMKFILE=#{lib}/esmf.mk"
        run 'python3', 'setup.py', 'install', "--prefix=#{prefix}"
      end
    end
  end
end
