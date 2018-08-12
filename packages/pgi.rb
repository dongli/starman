class Pgi < Package
  if OS.linux?
    url 'http://static.longrunweather.com/packages/pgilinux-2018-184-x86-64.tar.gz'
    #url 'https://download.pgroup.com/secure/pgilinux-2018-184-x86-64.tar.gz?VdJBUwzGhcDhR_F3XFcB0WZvCDTW0JFYbFrmkqEXgBvGhK0fXDSriGDROlUg5P0ieLDl_ajD59uZ2J5-KxvZeVuHCWgrdg_UAv0DrSsoy6FBLKaX_hMvFv82LbVLu-PJfzHsrmM'
    sha256 '81e0dcf6000b026093ece180d42d77854c23269fb8409cedcf51c674ca580a0f'
  end
  version '18.4'

  label :compiler
  label :not_link

  option 'with-nvidia', 'Install NVIDIA components, such as CUDA.'
  option 'with-amd', 'Install AMD components.'
  option 'with-java', 'Install JRE for PGI debugger and profiler.'
  option 'with-mpi', 'Install precompiled OpenMPI (not recommended).'
  option 'with-mpi-gpu', 'Install NVIDIA GPU support in OpenMPI.'

  def root
    "#{prefix}/linux86-64/#{version}"
  end

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

  def post_install
    # Update conf file to add this new compiler set.
    Settings.settings['compiler_sets']["pgi_#{version}"] = {
      'c' => "#{root}/bin/pgcc",
      'cxx' => "#{root}/bin/pgc++",
      'fortran' => "#{root}/bin/pgfortran"
    }
    Settings.write
    # Run makelocalrc.
    run "#{root}/bin/makelocalrc", root, '-x'
  end

  def export_env
    append_path "#{root}/bin"
    append_manpath "#{root}/man"
  end
end
