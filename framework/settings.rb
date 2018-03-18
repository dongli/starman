class Settings
  extend Utils

  def self.settings
    @@settings ||= {}
  end

  def self.cache_root
    '/tmp/starman'
  end

  def self.rc_root
    @@rc_root
  end

  def self.install_root
    settings['install_root']
  end

  def self.link_root package = nil
    if package
      if package.has_label? :alone
        File.dirname(package.prefix) + '/link'
      elsif package.has_label? :common
        common_root
      else
        link_root
      end
    else
      settings['link_root']
    end
  end

  def self.common_root
    "#{install_root}/common"
  end

  def self.conf_file
    "#{rc_root}/conf.yml"
  end

  def self.compiler_set
    CommandParser.args[:compiler_set] || settings['defaults']['compiler_set']
  end

  def self.compilers
    settings['compiler_sets'][compiler_set]
  end

  def self.c_compiler
    compilers['c']
  end

  def self.cxx_compiler
    compilers['cxx']
  end

  def self.fortran_compiler
    compilers['fortran']
  end

  def self.mpi_c_compiler
    compilers['mpi_c']
  end

  def self.mpi_cxx_compiler
    compilers['mpi_cxx']
  end

  def self.mpi_fortran_compiler
    compilers['mpi_fortran']
  end

  def self.nodes
    [settings['nodes']['master_node'], settings['nodes']['slave_nodes']].flatten.uniq
  end

  def self.master_node
    settings['nodes']['master_node']
  end

  def self.slave_nodes
    settings['nodes']['slave_nodes']
  end

  def self.init
    # rc_root has priority order: --rc-root > /var/starman > ~/.starman
    @@rc_root = CommandParser.args[:rc_root] || (File.directory?('/var/starman') ? '/var/starman' : "#{ENV['HOME']}/.starman")
    if File.file? conf_file
      @@settings = YAML.load(open(conf_file).read)
      CLI.error "#{CLI.red 'install_root'} is not set in #{CLI.blue conf_file}!" if not install_root or install_root == '<change_me>'
      settings['link_root'] = "#{Settings.install_root}/#{Settings.compiler_set}"
      set_compile_env
      if CommandParser.args[:verbose]
        CLI.notice "Use #{CLI.blue compiler_set} compilers."
        ['CC', 'CXX', 'FC', 'MPICC', 'MPICXX', 'MPIFC', 'MPIF90', 'MPIF77'].each do |env|
          CLI.notice "#{env} = #{CLI.blue ENV[env]}" if ENV[env]
        end
      end
    else
      begin
        CLI.notice "Create runtime configuration directory #{CLI.blue rc_root}."
        FileUtils.mkdir_p rc_root
        write_file conf_file, <<-EOS
---
install_root: <change_me>
defaults:
  compiler_set: <change_me>
compiler_sets:
  <change_me>:
    c: <change_me>
    cxx: <change_me>
    fortran: <change_me>
EOS
        CLI.notice "Please edit #{CLI.blue conf_file} to suit your environment and come back."
        exit
      rescue Errno::EACCES => e
        CLI.error "Failed to create runtime configuration directory at #{CLI.red rc_root}!\n#{e}"
      end
    end
  end
end
