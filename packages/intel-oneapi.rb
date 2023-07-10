class IntelOneapi < Package
  version '2023.1.0.46401'

  label :compiler

  resource :base do
    url 'https://registrationcenter-download.intel.com/akdlm/IRC_NAS/7deeaac4-f605-4bcf-a81b-ea7531577c61/l_BaseKit_p_2023.1.0.46401_offline.sh'
    sha256 '74a457082c529467ecf7fe62dfa83dd36b9b190857993708de60cbe5f017c332'
  end

  resource :hpc do
    url 'https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1ff1b38a-8218-4c53-9956-f0b264de35a4/l_HPCKit_p_2023.1.0.46346_offline.sh'
    sha256 '8822453afef9b6fb163e1d1096797f7bb65200b1ba300b5a8c044b4a0550de71'
  end

  def install
    install_resource :base, '.', plain_file: true
    args = %W[
      -a --install-dir #{prefix}
      --silent --eula accept
      --components
    ]
    components = %W[
      intel.oneapi.lin.dpcpp-ct
      intel.oneapi.lin.dpcpp-cpp-compiler
      intel.oneapi.lin.dpl
      intel.oneapi.lin.mkl.devel
    ]
    args << components.join(':')
    # run 'sh base/l_BaseKit_p_2023.1.0.46401_offline.sh', *args

    install_resource :hpc, '.', plain_file: true
    args = %W[
      -a --install-dir #{prefix}
      --silent --eula accept
      --components
    ]
    components = %W[
      intel.oneapi.lin.dpcpp-cpp-compiler-pro
      intel.oneapi.lin.ifort-compiler
      intel.oneapi.lin.mpi.devel
    ]
    args << components.join(':')
    run 'sh hpc/l_HPCKit_p_2023.1.0.46346_offline.sh', *args
  end

  def post_install
    # Update conf file to add this new compiler set.
    Settings.settings['compiler_sets']["intel_#{version}"] = {
      'c' => "#{prefix}/compiler/latest/linux/bin/icx",
      'mpi_c' => "#{prefix}/mpi/latest/bin/mpiicc",
      'cxx' => "#{prefix}/compiler/latest/linux/bin/icpx",
      'mpi_cxx' => "#{prefix}/mpi/latest/bin/mpiicpc",
      'fortran' => "#{prefix}/compiler/latest/linux/bin/ifx",
      'mpi_fortran' => "#{prefix}/mpi/latest/bin/mpiifort"
    }
    Settings.write
  end

end

