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
    @parser.on '--all', 'Remove all packages.' do
      @@args[:all] = true
    end
    parse_packages empty_is_ok: true
    @parser.parse!
  end

  def run
    @@package_group = nil
    if CommandParser.args[:all]
      History.installed_packages.each do |name, package|
        remove package
      end
    else
      PackageLoader.loaded_packages.each do |name, package|
        next if not PackageLoader.from_cmd_line? package and not CommandParser.args[:with_deps]
        remove package
      end
    end
  end

  def remove package
    if package.has_label? :group
      CLI.notice "Package group #{CLI.green package.name} is uninstalled."
      @@package_group = package.name
    elsif not History.installed? package and not package.skipped? and not package.group == @@package_group
      CLI.warning "Package #{CLI.red package.name} has not been installed."
    else
      if not @@package_group or not package.group == @@package_group
        CLI.notice "Uninstall package #{CLI.green package.name} #{CLI.blue package.version} ..."
      end
      PackageLinker.unlink package
      if Dir.exist? package.prefix
        FileUtils.rm_rf package.prefix
        # Remove empty directory.
        FileUtils.rmdir File.dirname(package.prefix) if Dir.glob("#{File.dirname(package.prefix)}/*").size == 0
      end
      History.remove_install package
    end
  end
end
