class Ofed < Package
  url 'http://www.mellanox.com/downloads/ofed/MLNX_OFED-4.4-2.0.7.0/MLNX_OFED_SRC-4.4-2.0.7.0.tgz'
  sha256 '206ea006aac540f9704b2e4153769046c6a69e8984ca68e8debf1ddccb6ccc7a'

  label :wild

  option 'mode', 'Install mode.', type: :string, choices: ['all', 'hpc', 'basic'], default: 'hpc'

  def install
    CLI.error 'OFED is only supported in CentOS now!' if not OS.centos?
    CLI.error "Invalid mode #{CLI.red mode}!" unless ['all', 'basic', 'hpc'].include? mode
    run './install.pl', "--#{mode}", '--enable-opensm'
    CLI.warning 'OFED RPMs are installed in /usr and /opt.'
  end
end
