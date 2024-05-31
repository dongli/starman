class Esmf < Package
  url 'https://github.com/esmf-org/esmf/archive/refs/tags/v8.6.0.tar.gz'
  sha256 'ed057eaddb158a3cce2afc0712b49353b7038b45b29aee86180f381457c0ebe7'
  version '8.6.0'
  file_name 'esmf-8.6.0.tar.gz'

  option 'use-mkl', 'Use MKL for LAPACK dependency.'
  option 'use-pnetcdf', 'Use Parallel-NetCDF dependency.'
  option 'use-pio', 'Use PIO dependency.'
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
  depends_on :pio if use_pio?

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
    if use_pio?
      ENV['ESMF_PIO'] = Pio.prefix
      ENV['ESMF_PIO_INCLUDE'] = Pio.inc
    else
      ENV['ESMF_PIO'] = 'OFF'
    end
    if mpi_type
      ENV['ESMF_COMM'] = mpi_type.to_s
    elsif ENV['MPICXX'] =~ /mpiicpx$/ or ENV['MPICXX'] =~ /mpiicpc$/ or ENV['MPIFC'] =~ /mpiifort$/
      ENV['ESMF_COMM'] = 'intelmpi'
    else
      CLI.error "You should set #{CLI.blue '--mpi-type'} option!"
    end
    inreplace 'build_config/Linux.gfortran.default/ESMC_Conf.h', {
      'typedef size_t ESMCI_FortranStrLenArg;' => "#include <stddef.h>\ntypedef size_t ESMCI_FortranStrLenArg;"
    }
    ENV['ESMF_CCOMPILER'] = ENV['MPICC']
    ENV['ESMF_CLINKER'] = ENV['MPICC']
    ENV['ESMF_CXXCOMPILER'] = ENV['MPICXX']
    ENV['ESMF_CXXLINKER'] = ENV['MPICXX']
    ENV['ESMF_F90COMPILER'] = ENV['MPIFC']
    ENV['ESMF_F90LINKER'] = ENV['MPIFC']
    if OS.mac? and CompilerSet.c.vendor == :gcc
      ['src/Infrastructure/IO/PIO/configure',
       'src/Infrastructure/IO/PIO/ParallelIO/tests/cperf/CMakeLists.txt',
       'src/Infrastructure/IO/PIO/ParallelIO/examples/c/CMakeLists.txt',
       'src/Infrastructure/IO/PIO/ParallelIO/src/clib/CMakeLists.txt',
       'src/Infrastructure/IO/PIO/ParallelIO/tests/cunit/CMakeLists.txt',
       'src/Infrastructure/IO/PIO/ParallelIO/.github/workflows/autotools.yml'].each do |file|
        inreplace file, '-std=c99' => '-std=gnu11'
      end
      ENV['ESMF_CSTD'] = 'gnu11'
      inreplace 'build/common.mk', 'ESMF_CSTDFLAG         = -std=c$(ESMF_CSTD)' => 'ESMF_CSTDFLAG = -std=$(ESMF_CSTD)'
    end
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
