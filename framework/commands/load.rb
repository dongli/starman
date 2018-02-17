class LoadCommand < CommandParser
  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman load <package_name>[@<package_version>] ...
EOS
    @parser.on '-cNAME', '--compiler-set NAME', 'Set the active compiler set by its name set in conf file.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @parser.on '-a', '--all', 'Load all packages for current compiler set.' do
      @@args[:all] = true
    end
    @parser.on '-p', '--print', 'Print modified environment variables.' do
      @@args[:print] = true
      @@args[:verbose] = false
    end
    @parser.parse!
    parse_packages
  end

  def run
    if @@args[:all]
      ENV['PATH'] = "#{Settings.link_root}/bin:#{ENV['PATH']}" if File.directory? "#{Settings.link_root}/bin"
      ENV[OS.ld_library_path] = "#{Settings.link_root}/lib:#{ENV[OS.ld_library_path]}" if File.directory? "#{Settings.link_root}/lib"
      ENV[OS.ld_library_path] = "#{Settings.link_root}/lib64:#{ENV[OS.ld_library_path]}" if File.directory? "#{Settings.link_root}/lib64"
    else
      @packages.keys.each do |package_name|
        package = @packages[package_name]
        next unless PackageLoader.from_cmd_line? package
        if not History.installed? package
          CLI.warning "Package #{CLI.red package_name} has not been installed."
        else
          CLI.notice "Load package #{CLI.green package.name}@#{CLI.blue package.version} ..." if CommandParser.args[:verbose]
          ENV['PATH'] = "#{package.opt_bin}:#{ENV['PATH']}" if package.opt_bin
          ENV[OS.ld_library_path] = "#{package.opt_lib}:#{ENV[OS.ld_library_path]}" if package.opt_lib
          ENV[OS.ld_library_path] = "#{package.opt_lib64}:#{ENV[OS.ld_library_path]}" if package.opt_lib64
        end
      end
    end
    if @@args[:print]
      print "export PATH=#{ENV['PATH']}\n"
      print "export #{OS.ld_library_path}=#{ENV[OS.ld_library_path]}\n"
    end
  end
end