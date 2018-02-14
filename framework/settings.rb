class Settings
  def self.cache_root
    '/tmp/starman'
  end

  def self.rc_root
    @@rc_root
  end

  def self.install_root
    @@settings['install_root']
  end

  def self.link_root
    @@settings['link_root']
  end

  def self.conf_file
    "#{rc_root}/starman.yml"
  end

  def self.compiler_set
    @@settings['defaults']['compiler_set']
  end

  def self.compilers
    @@settings['compiler_sets'][compiler_set]
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

  def self.init
    # rc_root has priority order: --rc-root > /var/starman > ~/.starman
    @@rc_root = CommandParser.args[:rc_root] || File.directory?('/var/starman') ? '/var/starman' : "#{ENV['HOME']}/.starman"
    if File.file? conf_file
      @@settings = YAML.load(open(conf_file).read)
      @@settings['link_root'] = "#{Settings.install_root}/#{Settings.compiler_set}"
      ENV['CC'] = c_compiler
      ENV['CXX'] = cxx_compiler
      ENV['FC'] = fortran_compiler
      ENV['F77'] = fortran_compiler
    else
      begin
        FileUtils.mkdir_p rc_root
      rescue Errno::EACCES => e
        CLI.error "Failed to create runtime configuration directory at #{CLI.red rc_root}!\n#{e}"
      end
    end
  end
end
