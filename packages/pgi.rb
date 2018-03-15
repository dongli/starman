class Pgi < Package
  if OS.linux?
    url 'http://download.pgroup.com/secure/pgilinux-2017-1710-x86_64.tar.gz?K7SF2BG6tl-RRYQb13oRUUwyjZ0S-72vX35ceD1ZO5xvqSk8Ec7e3wsPvt3JK9ZRDozSrEilpKnA0q-d2EYJk5KpBb5o-y5X14Zjh-f3Id9tOwHAEr6jMRT5WQ4tkhadwLhwNcaQ'
    sha256 '9da8f869fb9b70c0c4423c903d40a9e22d54b997af359a43573c0841165cd1b6'
    file_name 'pgilinux-2017-1710-x86_64.tar.gz'
  end
  version '17.10'

  label :compiler

  option 'with-nvidia', 'Install NVIDIA components, such as CUDA.'
  option 'with-amd', 'Install AMD components.'
  option 'with-java', 'Install JRE for PGI debugger and profiler.'
  option 'with-mpi', 'Install precompiled OpenMPI (not recommended).'
  option 'with-mpi-gpu', 'Install NVIDIA GPU support in OpenMPI.'

  link "#{prefix}/linux86-64/#{version}/bin/*", 'bin'

  def install
    ENV['PGI_SILENT'] = 'true'
    ENV['PGI_ACCEPT_EULA'] = 'accept'
    ENV['PGI_INSTALL_DIR'] = prefix
    ENV['PGI_INSTALL_TYPE'] = 'network'
    ENV['PGI_INSTALL_LOCAL_DIR'] = '/var/pgi'
    ENV['PGI_INSTALL_NVIDIA'] = with_nvidia?.to_s
    ENV['PGI_INSTALL_AMD'] = with_amd?.to_s
    ENV['PGI_INSTALL_JAVA'] = with_java?.to_s
    ENV['PGI_INSTALL_MPI'] = with_mpi?.to_s
    ENV['PGI_MPI_GPU_SUPPORT'] = with_mpi_gpu?.to_s
    run './install'
  end
end
