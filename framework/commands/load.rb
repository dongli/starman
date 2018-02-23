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
      append_path Package.link_bin if Package.link_bin
      append_ld_library_path Package.link_lib if Package.link_lib
      append_ld_library_path Package.link_lib64 if Package.link_lib64
      append_path Package.common_bin if Package.common_bin
      append_ld_library_path Package.common_lib if Package.common_lib
      append_ld_library_path Package.common_lib64 if Package.common_lib64
    else
      PackageLoader.loaded_packages.each do |name, package|
        next unless PackageLoader.from_cmd_line? package
        if package.has_label? :group
          CLI.notice "Load package group #{CLI.green package.name}@#{CLI.blue package.version} ..." if CommandParser.args[:verbose]
        elsif not History.installed? package
          CLI.warning "Package #{CLI.red package.name}@#{CLI.blue package.name} has not been installed."
        else
          CLI.notice "Load package #{CLI.green package.name}@#{CLI.blue package.version} ..." if CommandParser.args[:verbose]
          append_path package.bin if package.bin
          append_ld_library_path package.lib if package.lib
          append_ld_library_path package.lib64 if package.lib64
        end
      end
    end
    if @@args[:print]
      print "export PATH=#{ENV['PATH']}\n"
      print "export #{OS.ld_library_path}=#{ENV[OS.ld_library_path]}\n"
    end
  end
end
