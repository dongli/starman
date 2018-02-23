class Mvapich2 < Package
  url 'http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.2.tar.gz'
  sha256 '791a6fc2b23de63b430b3e598bf05b1b25b82ba8bf7e0622fc81ba593b3bb131'

  conflicts_with :openmpi, :mpich2

  option 'enable-debug', 'Enable debug messages, may impact performance.'
  # TODO: Should we add slurm dependency?
  option 'enable-slurm-1', 'Enable PMI-1 support in SLURM.'
  option 'enable-slurm-2', 'Enable PMI-2 support in SLURM.'
  option 'with-omni-path', 'Build for Intel Omni-Path devices.'
  option 'with-truescale', 'Build for Intel TrueScale devices.'

  depends_on :yacc
  depends_on :hwloc

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fortran=all
      CPPFLAGS='-I#{common_include}'
      LDFLAGS='-L#{common_lib}'
    ]
    # NOTE: IB library from vendors should already been installed.
    if with_omni_path?
      args << '--with-device=ch3:psm'
    elsif with_truescale?
      args << '--with-device=ch3:psm'
    else
      args << '--with-device=ch3:mrail --with-rdma=gen2'
    end
    args << '--enable-g=all --enable-error-messages=all' if enable_debug?
    if enable_slurm_1?
      args << '--with-pmi=pmi1 --with-pm=slurm'
    elsif enable_slurm_2?
      args << '--with-pmi=pmi2 --with-pm=slurm'
    end
    run './configure', *args
    run 'make'
    run 'make', 'install'
  end
end
