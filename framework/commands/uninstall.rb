class UninstallCommand < CommandParser
  include Utils

  def initialize
    super
    @parser.banner += <<-EOS

    >>> starman uninstall <package_name> ... [options]
EOS
    @parser.on '-cNAME', '--compiler-set NAME', 'Set the active compiler set by its name set in conf file.' do |compiler_set|
      @@args[:compiler_set] = compiler_set
    end
    @parser.on '--with-deps', 'Also uninstall dependency packages.' do
      @@args[:with_deps] = true
    end
    parse_packages
    @parser.parse!
  end

  def run
    PackageLoader.loaded_packages.each do |name, package|
      next if not PackageLoader.from_cmd_line? package and not CommandParser.args[:with_deps]
      if package.has_label? :group
        CLI.notice "Package group #{CLI.green package.name} is uninstalled."
      elsif not History.installed? package
        CLI.warning "Package #{CLI.red package.name} has not been installed."
      else
        CLI.notice "Uninstall package #{CLI.green package.name} ..."
        PackageLinker.unlink package
        FileUtils.rm_rf package.prefix
        # Remove empty directory.
        FileUtils.rmdir File.dirname(package.prefix) if Dir.glob("#{File.dirname(package.prefix)}/*").size == 0
        History.remove_install package
      end
    end
  end
end
